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

final class StatsViewModel: ObservableObject {
  @Published private(set) var stats: [Stat] = []
  @Published private(set) var filteredStats: [Stat] = []
  
  private var manager: QuizSessionManager = .init(context: PersistenceController.shared.container.viewContext)
  
  init(cdManager: QuizSessionManager? = nil) {
    if let cdManager {
      manager = cdManager
    }
    
    stats = manager.fetchAllStats()
    filteredStats = stats
  }
  
  func filterBy(selectedModifier: IntervalModifier) {
    filteredStats = stats.filter { $0.intervalModifier == selectedModifier.abbrDescription }
  }
  
  // 정답률을 계산하여 리턴
  var answerStatuses: [String : AnswerStatus] {
    var result: [String : AnswerStatus] = [:]

    // stats 배열 순회
    for stat in stats {
      let key = "\(stat.intervalModifier)\(stat.intervalNumber)"
      
      var currentData = result[key, default: .init(correct: 0, total: 0)]
      currentData.total += 1
      if stat.isCorrect {
        currentData.correct += 1
      }
      
      // 업데이트된 데이터를 사전에 반영
      result[key] = currentData
    }

    return result
  }
}
