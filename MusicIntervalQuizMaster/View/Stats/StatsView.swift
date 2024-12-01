//
//  StatsView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct StatsView: View {
  @StateObject var viewModel = StatsViewModel()
  
  @State private var selectedDegree: Int? = nil
  @State private var selectedSolved: SolvingStatus? = nil
  @State private var selectedQuality: IntervalModifier? = nil
  @State private var selectedFilter: Filter = .Quality
  
  enum Filter: String, CaseIterable {
    case Quality, Degree, Solved
  }
  
  enum SolvingStatus: String, CaseIterable {
    case Unsolved, Correct, Wrong
  }
  
  // 두 개의 열을 가진 Grid 설정
  let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]
  
  var body: some View {
    NavigationStack {
      ChartView()
        .padding(.horizontal, 10)
        .frame(height: 200)
      
      ScrollView(.horizontal) {
        HStack {
          Menu {
            ForEach(Filter.allCases, id: \.self) { filter in
              Button(action: {
                selectedFilter = filter
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
      
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(1...13, id: \.self) { currentDegree in
            ForEach(IntervalModifier.availableModifierList(of: currentDegree), id: \.self) { modifier in
              let degreeText = "\(modifier.localizedDescription) \(currentDegree)도"
              let abbrText = "\(modifier.localizedAbbrDescription)\(currentDegree)"
              
              NavigationLink {
                Text("b")
              } label: {
                let answerStatus = viewModel.answerStatuses[abbrText]
                cell(degreeText: degreeText, abbrText: abbrText, answerStatus: answerStatus)
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
  private var degreeFilterView: some View {
    let cornerRadius: CGFloat = 17
    let padding: CGFloat = 6
    
    return HStack {
      // 전체보기 버튼
      Button(action: {
        
      }) {
        Text("ALL")
          .fontWeight(.medium)
          .padding(padding)
          .frame(width: 50)
          .foregroundColor(.white)
          .background(selectedDegree == nil ? Color.orange : Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
      }
      
      ForEach(1...13, id: \.self) { index in
        Button(action: {
          selectedDegree = (selectedDegree == index) ? nil : index // 이미 선택된 숫자를 클릭하면 해제
        }) {
          Text("\(index)")
            .fontWeight(.medium)
            .padding(padding)
            .frame(width: 40)
            .background(selectedDegree == index ? Color.orange : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
      }
    }
  }
  
  private var qualityFilterView: some View {
    let cornerRadius: CGFloat = 17
    let padding: CGFloat = 6
    
    return HStack {
      // 전체보기 버튼
      Button(action: {
        selectedQuality = nil
      }) {
        Text("ALL")
          .fontWeight(.medium)
          .padding(padding)
          .frame(width: 50)
          .foregroundColor(.white)
          .background(selectedQuality == nil ? Color.orange : Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
      }
      
      ForEach(IntervalModifier.allCases, id: \.self) { modifier in
        Button(action: {
          selectedQuality = modifier
        }) {
          Text("\(modifier.shortLocalizedDescription)")
            .fontWeight(.medium)
            .padding(padding)
            .background(selectedQuality == modifier ? Color.orange : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
      }
    }
  }
  
  private var solvedFilterView: some View {
    let cornerRadius: CGFloat = 17
    let padding: CGFloat = 6
    
    return HStack {
      // 전체보기 버튼
      Button(action: {
        
      }) {
        Text("ALL")
          .fontWeight(.medium)
          .padding(padding)
          .frame(width: 50)
          .foregroundColor(.white)
          .background(selectedSolved == nil ? Color.orange : Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
      }
      
      ForEach(SolvingStatus.allCases, id: \.self) { status in
        Button(action: {
          selectedSolved = status
        }) {
          Text("\(status)")
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
    let rate = answerStatus?.rate
    let rateString = answerStatus?.rate.percentageString ?? "-"
    let gradient = rate == nil ? neutralGradient : gradientColors(percentage: rate!)
    let countString = answerStatus == nil ? "- / -" : "\(answerStatus!.correct) / \(answerStatus!.total)"
    
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

    startColor = .init(red: 0.7 - percentage, green: percentage * 0.6, blue: 0.1)
    midColor = .init(red: 0.85 - percentage, green: percentage * 0.7, blue: 0.1)
    endColor = .init(red: 1 - percentage, green: percentage * 0.8, blue: 0.1)

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
