//
//  StatsView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct StatsView: View {
  @StateObject var viewModel = StatsViewModel()
  
  @State private var selectedFilter: Filter = .Quality
  
  // 필터가 선택된 경우 반드시 세 개 중 하나만 값이 있어야 하고, 나머지는 nil
  @State private var selectedDegree: Int? = nil
  @State private var selectedSolved: SolvingStatus? = nil
  @State private var selectedQuality: IntervalModifier? = nil
  
  @State private var chartPageForAnimation: Int = 0
  
  // 두 개의 열을 가진 Grid 설정
  let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]
  
  var body: some View {
    NavigationStack {
      VStack {
        Picker("선택", selection: $viewModel.selectedYSegment) {
          Text("by Accuracy").tag(0)
          Text("by Response Time").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle()) // 세그먼트 바 스타일
        .frame(height: 20)
        .padding(.horizontal, 10)
        
        ChartView(viewModel: viewModel)
          .padding(.horizontal, 10)
          .frame(height: CHART_VERTICAL_SIZE)
          .transaction { transaction in
            // ChartView의 업데이트는 애니메이션 없이 적용
            transaction.animation = nil
          }
      }
      .onChange(of: viewModel.currentChartPage) { page in
          chartPageForAnimation = page
        
        withAnimation {
          viewModel.answerStatuses(ChartXCategory.categories[page])
        }
      }
      
      ScrollView(.horizontal) {
        HStack {
          Menu {
            ForEach(Filter.allCases, id: \.self) { filter in
              Button(action: {
                selectedFilter = filter
                nullifyAllFilter()
              }) {
                Text(filter.rawValue)
              }
            }
          } label: {
            Label("\(selectedFilter)", systemImage: "line.horizontal.3.decrease.circle.fill")
              .fontWeight(.medium)
              .padding(.horizontal, 8)
              .padding(.vertical, 6)
              .foregroundColor(.white)
              .background(Color.red)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
          
          switch selectedFilter {
          case .Quality:
            qualityFilterView
          case .Degree:
            degreeFilterView
          case .Solved:
            solvedFilterView
          }
        }
      }
      .padding(.horizontal, 10)
      .padding(.bottom, 5)
      
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          // Filter 1: 도수
          let availableDegreeList = Array(1...13).filter { degree in
            guard let selectedDegree else {
              return true
            }
            
            return selectedDegree == degree
          }
          
          ForEach(availableDegreeList, id: \.self) { currentDegree in
            // Filter 2: 종류
            let availableModifierList = IntervalModifier.availableModifierList(of: currentDegree).filter { modifier in
              guard let selectedQuality else {
                return true
              }
              
              return selectedQuality.abbrDescription == modifier.abbrDescription
            }
            
            ForEach(availableModifierList, id: \.self) { modifier in
              let degreeText = "\(modifier.localizedDescription) \(currentDegree)도"
              let abbrText = "\(modifier.abbrDescription)\(currentDegree)"
               
              // Filter 3: 풀었는지 여부
              let answerStatus = viewModel.statuses[abbrText]
              if checkVisibility(answerStatus: answerStatus) {
                cellNaviLink(answerStatus: answerStatus, degreeText: degreeText, abbrText: abbrText)
              }
            }
          }
        }
      }
      .padding(.horizontal, 10)
    }
  }
}

extension StatsView {
  private func checkVisibility(answerStatus: AnswerStatus?) -> Bool {
    guard let selectedSolved else {
      return true
    }
    
    guard let answerStatus else {
      return selectedSolved == .unsolved
    }
    
    return switch selectedSolved {
    case .solved:
      true
    case .unsolved:
      false
    case .correct100:
      answerStatus.rate == 1.0
    case .correct0:
      answerStatus.rate == 0.0
    case .rate1_5:
      0.0..<0.2 ~= answerStatus.rate
    case .rate2_5:
      0.2..<0.4 ~= answerStatus.rate
    case .rate3_5:
      0.4..<0.6 ~= answerStatus.rate
    case .rate4_5:
      0.6..<0.8 ~= answerStatus.rate
    case .rate5_5:
      0.8...1.0 ~= answerStatus.rate
    }
  }
  
  private func nullifyAllFilter() {
    selectedDegree = nil
    selectedSolved = nil
    selectedQuality = nil
  }
  
  private func turnOnFilter(_ filter: Filter, value: Any?) {
    switch filter {
    case .Quality:
      selectedQuality = value as? IntervalModifier
      selectedDegree = nil
      selectedSolved = nil
    case .Degree:
      selectedDegree = value as? Int
      selectedSolved = nil
      selectedQuality = nil
    case .Solved:
      selectedSolved = value as? SolvingStatus
      selectedDegree = nil
      selectedQuality = nil
    }
  }
  
  private func cellNaviLink(answerStatus: AnswerStatus?, degreeText: String, abbrText: String) -> some View {
    // TODO: - NavLink로 상세 정보 제공 (다음 버전)
    cell(degreeText: degreeText, abbrText: abbrText, answerStatus: answerStatus)
  }
  
  private func allButton(padding: CGFloat, cornerRadius: CGFloat, filter: Any?) -> some View {
    Button(action: {
      nullifyAllFilter()
    }) {
      Text("ALL")
        .fontWeight(.medium)
        .padding(padding)
        .frame(width: 50)
        .foregroundColor(.white)
        .background(filter == nil ? Color.orange : Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
  }

  private var degreeFilterView: some View {
    let cornerRadius: CGFloat = 17
    let padding: CGFloat = 6
    
    return HStack {
      // 전체보기 버튼
      allButton(padding: padding, cornerRadius: cornerRadius, filter: selectedDegree)
      
      ForEach(1...13, id: \.self) { degree in
        Button(action: {
          turnOnFilter(.Degree, value: degree)
        }) {
          Text("\(degree)")
            .fontWeight(.medium)
            .padding(padding)
            .frame(width: 40)
            .background(selectedDegree == degree ? Color.orange : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
      }
    }
  }
  
  private var qualityFilterView: some View {
    let cornerRadius: CGFloat = 15
    let padding: CGFloat = 6
    
    return HStack {
      // 전체보기 버튼
      allButton(padding: padding, cornerRadius: cornerRadius, filter: selectedQuality)
      
      ForEach(IntervalModifier.allCases, id: \.self) { modifier in
        Button(action: {
          turnOnFilter(.Quality, value: modifier)
        }) {
          Text("\(modifier.localizedDescription)")
            .fontWeight(.medium)
            .padding(.vertical, padding)
            .padding(.horizontal, 10)
            .background(selectedQuality == modifier ? Color.orange : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
      }
    }
  }
  
  private var solvedFilterView: some View {
    let cornerRadius: CGFloat = 14
    let padding: CGFloat = 6
    
    return HStack {
      // 전체보기 버튼
      allButton(padding: padding, cornerRadius: cornerRadius, filter: selectedSolved)
      
      
      ForEach(SolvingStatus.allCases, id: \.self) { status in
        Button(action: {
          turnOnFilter(.Solved, value: status)
        }) {
          Text("\(status.localizedDescription)")
            .fontWeight(.medium)
            .padding(padding)
            .background(selectedSolved == status ? Color.orange : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
      }
    }
  }
}

extension StatsView {
  @ViewBuilder private func cell(degreeText: String, abbrText: String, answerStatus: AnswerStatus?) -> some View {
    let currentCategory = ChartXCategory.categories[chartPageForAnimation]
    
    let rate = answerStatus?.rate
    let rateString = answerStatus?.rate.percentageString ?? "-"
    let gradient = rate == nil ? neutralGradient : gradientColors(percentage: rate!)
    let countString = answerStatus == nil ? "- / -" : "\(answerStatus!.correct) / \(answerStatus!.total)"
    
    let categoryText = switch currentCategory.category {
    case .basic:
      ""
    case .clef:
      currentCategory.clef.shortLocalizedDescription
    case .direction:
      currentCategory.direction.localizedDescription
    }
    
    HStack {
      VStack(alignment: .leading) {
        Text("\(degreeText)")
          .font(.title3).bold()
        Text("\(abbrText)")
          .font(.callout)
          .opacity(0.8)
      }
      Spacer()
      VStack(spacing: 0) {
        if currentCategory.category != .basic {
          Text(categoryText)
            .font(.system(size: 10))
            .opacity(0.8)
        }
        Text(rateString)
          .font(.title2)
          .fontWeight(.semibold)
        Text(countString)
          .font(.system(size: 10))
          .opacity(0.8)
      }
    }
    .padding(15)
    .frame(height: 100)
    .frame(maxWidth: .infinity)
    .background(
      LinearGradient(
        gradient: gradient,
        startPoint: .bottomTrailing,
        endPoint: .topLeading
      )
    )
    .foregroundColor(.white)
    .cornerRadius(8)
    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
  }
  
  var neutralGradient: Gradient {
    Gradient(colors: [.init(white: 0.61), .init(white: 0.52)])
  }
  
  func gradientColors(percentage: Double) -> Gradient {
    // 값 보정: 0 ~ 1 사이로 클램핑
    let percentage = min(max(percentage, 0), 1)

    // 색상 계산: 빨강(0.0) → 노랑(0.5) → 초록(1.0)
    let startColor: Color
    let midColor: Color
    let endColor: Color

    startColor = .init(red: 0.8 - percentage, green: percentage * 0.6, blue: 0.3)
    midColor = .init(red: 0.9 - percentage, green: percentage * 0.7, blue: 0.3)
    endColor = .init(red: 1 - percentage, green: percentage * 0.8, blue: 0.3)

    return Gradient(colors: [startColor, midColor, endColor])
  }

}

#Preview {
  StatsView(
    viewModel: StatsViewModel(
      cdManager: .init(
        context: PersistenceController.preview.container.viewContext)
    )
  )
}
