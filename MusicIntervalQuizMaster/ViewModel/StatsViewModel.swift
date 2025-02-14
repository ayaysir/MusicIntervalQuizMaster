//
//  StatsViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import Foundation

struct AnswerStatus {
  var correct: Int
  var total: Int
  
  var rate: Double {
    Double(correct) / Double(total)
  }
}

enum ChartXCategory: CaseIterable, Hashable {
  case basic, clef, direction
  
  struct Parameters: Hashable {
    let category: ChartXCategory
    let clef: Clef
    let direction: IntervalPairDirection
    
    init(_ category: ChartXCategory, _ clef: Clef, _ direction: IntervalPairDirection) {
      self.category = category
      self.clef = clef
      self.direction = direction
    }
  }
  
  static var categories: [Parameters] {
    [
      Parameters(.basic, .treble, .ascending),
      Parameters(.clef, .treble, .ascending),
      Parameters(.clef, .bass, .ascending),
      Parameters(.clef, .alto, .ascending),
      Parameters(.direction, .treble, .ascending),
      Parameters(.direction, .treble, .descending),
      Parameters(.direction, .treble, .simultaneously),
    ]
  }
}

final class StatsViewModel: ObservableObject {
  @Published private(set) var stats: [Stat] = []
  @Published private(set) var filteredStats: [Stat] = []
  @Published private(set) var statuses: [String : AnswerStatus] = [:]
  
  @Published var selectedYSegment = 0
  @Published var currentChartPage: Int = 0
  
  private var manager: QuizSessionManager = .init(context: PersistenceController.shared.container.viewContext)
  
  init(cdManager: QuizSessionManager? = nil) {
    if let cdManager {
      manager = cdManager
    }
    
    fetchStats()
  }
  
  func fetchStats() {
    stats = manager.fetchAllStats()
    filteredStats = stats
    print("Stats count:", stats.count, filteredStats.count)
    
    answerStatuses(.init(.basic, .treble, .ascending))
  }
  
  func filterBy(selectedModifier: IntervalModifier) {
    filteredStats = stats.filter { $0.intervalModifier == selectedModifier.abbrDescription }
  }
  
  // 정답률을 계산하여 리턴
  func answerStatuses(_ categoryParameters: ChartXCategory.Parameters) {
    statuses = [:]

    // stats 배열 순회
    for stat in stats {
      switch categoryParameters.category {
      case .basic:
        break
      case .clef:
        if stat.clef != categoryParameters.clef.dataDescription {
          continue
        }
      case .direction:
        if stat.direction != categoryParameters.direction.dataDescription {
          continue
        }
      }
      
      let key = "\(stat.intervalModifier)\(stat.intervalNumber)"
      
      var currentData = statuses[key, default: .init(correct: 0, total: 0)]
      currentData.total += 1
      if stat.isCorrect {
        currentData.correct += 1
      }
      
      // 업데이트된 데이터를 사전에 반영
      statuses[key] = currentData
    }
  }
}

extension StatsViewModel {
  func generateBarChartData(
    by category: ChartXCategory = .basic,
    clef: Clef = .treble,
    direction: IntervalPairDirection = .ascending
  ) -> [BarChartData] {
    
    let filteredStats = stats.filter { stat in
      return switch category {
      case .basic:
        true
      case .clef:
        stat.clef == clef.dataDescription
      case .direction:
        stat.direction == direction.dataDescription
      }
    }
    
    // 그룹화
    let groupedByModifier = Dictionary(grouping: filteredStats, by: { $0.intervalModifier })
    let customModifierOrder: [String] = [
      IntervalModifier.perfect.chartLocalizedDescription,
      IntervalModifier.major.chartLocalizedDescription,
      IntervalModifier.minor.chartLocalizedDescription,
      IntervalModifier.augmented.chartLocalizedDescription,
      IntervalModifier.diminished.chartLocalizedDescription,
      IntervalModifier.doublyAugmented.chartLocalizedDescription,
      IntervalModifier.doublyDiminished.chartLocalizedDescription
    ]
    
    // 데이터 가공
    return groupedByModifier.map { (modifier, stats) in
      let correctStats = stats.filter { $0.isCorrect }
      let correctCount = correctStats.count
      let totalCount = stats.count
      let accuracy = totalCount > 0 ? Double(correctCount) / Double(totalCount) : 0.0

      // 정답 시간 계산 (firstTryTime - startTime)
      let totalResponseTime = correctStats.reduce(0.0) { result, stat in
        result + stat.finalAnswerTime.timeIntervalSince(stat.startTime)
      }
      let averageResponseTime = correctCount > 0 ? totalResponseTime / Double(correctCount) : 0.0

      return BarChartData(
        intervalModifier: IntervalModifier.from(abbreviation: modifier)?.chartLocalizedDescription ?? modifier,
        correctCount: correctCount,
        totalCount: totalCount,
        accuracy: accuracy,
        averageResponseTime: averageResponseTime
      )
    }.sorted { item1, item2 in
      guard
        let index1 = customModifierOrder.firstIndex(of: item1.intervalModifier),
        let index2 = customModifierOrder.firstIndex(of: item2.intervalModifier)
      else {
        return false
      }
      
      return index1 < index2
    }
  }
}
