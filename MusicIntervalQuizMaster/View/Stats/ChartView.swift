//
//  ChartView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI
import Charts

struct ChartView: View {
  @StateObject var viewModel: StatsViewModel
  
  var body: some View {
    TabView(selection: $viewModel.currentChartPage) {
      ForEach(ChartXCategory.categories.indices, id: \.self) { index in
        let parameters = ChartXCategory.categories[index]
        let data: [BarChartData] = viewModel.generateBarChartData(by: parameters.category, clef: parameters.clef, direction: parameters.direction)
        
        ZStack {
          if data.isEmpty {
            let title = switch parameters.category {
            case .basic:
              "by Interval Quality"
            case .clef:
              "\(parameters.clef.localizedDescription)"
            case .direction:
              "\(parameters.direction.localizedDescription) direction"
            }
            
            VStack {
              Text(title)
                .font(.subheadline).bold()
              Text("There is no data yet.")
                .font(.caption)
            }
            
          } else {
            if viewModel.selectedYSegment == 0 {
              rateBarChart(
                data,
                category: parameters.category,
                clef: parameters.clef,
                direction: parameters.direction
              )
            } else {
              timeBarChart(
                data,
                category: parameters.category,
                clef: parameters.clef,
                direction: parameters.direction
              )
            }
          }
          
        }
        .tag(parameters)
      }
      .padding(.bottom, 20)
    }
    .tabViewStyle(.page)
  }
}

extension ChartView {
  @ViewBuilder private func rateBarChart(
    _ data: [BarChartData],
    category: ChartXCategory,
    clef: Clef = .treble,
    direction: IntervalPairDirection = .ascending
  ) -> some View {
    ZStack(alignment: .topLeading) {
      let title = switch category {
      case .basic:
        "Accuracy by Interval Quality"
      case .clef:
        "Accuracy - \(clef.localizedDescription) only"
      case .direction:
        "Accuracy - \(direction.localizedDescription) direction only"
      }
      
      Text(title)
        .font(.subheadline).bold()
      Chart(data) { item in
        BarMark(
          x: .value("Quality", item.intervalModifier),
          y: .value("Correct Rates", item.accuracy)
        )
        .foregroundStyle(
          LinearGradient(
            colors: [Color.cyan.opacity(0.95), interpolatedColorByRate(for: item.accuracy).opacity(0.75)],
            startPoint: .top,
            endPoint: .bottom
          )
        )
      }
      .chartYAxis {
        AxisMarks(position: .trailing, values: .stride(by: 0.2)) { value in
          if let percent = value.as(Double.self) {
            AxisValueLabel {
              Text("\(percent.percentageStringWithoutMark)")
            }
          }
          
          // AxisTick() // 눈금 표시
          AxisGridLine() // 그리드라인 표시
        }
      }
      .chartYAxisLabel("Accuracy (%)")
    }
    .padding(10)
  }
  
  @ViewBuilder private func timeBarChart(
    _ data: [BarChartData],
    category: ChartXCategory,
    clef: Clef = .treble,
    direction: IntervalPairDirection = .ascending
  ) -> some View {
    ZStack(alignment: .topLeading) {
      let title = switch category {
      case .basic:
        "Response Time by Interval Quality"
      case .clef:
        "Time - \(clef.localizedDescription) only"
      case .direction:
        "Time - \(direction.localizedDescription) direction only"
      }
      
      Text(title)
        .font(.subheadline).bold()
      Chart(data) { item in
        BarMark(
          x: .value("Quality", item.intervalModifier),
          y: .value("Time", item.averageResponseTime)
        )
        .foregroundStyle(
          LinearGradient(
            colors: [Color.cyan.opacity(0.95), interpolatedColorByTime(for: item.averageResponseTime).opacity(0.75)],
            startPoint: .top,
            endPoint: .bottom
          )
        )
      }
      .chartYAxisLabel("Time (s)")
    }
    .padding(10)
  }
}

extension ChartView {
  func interpolatedColorByRate(for value: Double) -> Color {
    let clampedValue = min(max(value, 0), 1) // 값 제한 (0.0 ~ 1.0)
    
    return switch clampedValue {
    case 0..<0.4:
        .red
    case 0.4..<0.75:
        .purple
    case 0.75...1:
        .green
    default:
        .purple
    }
  }
  
  func interpolatedColorByTime(for value: Double) -> Color {
    return switch value {
    case 0...10:
        .green
    case 11...30:
        .purple
    case 31...:
        .red
    default:
        .purple
    }
  }
}

#Preview {
  let viewModel = StatsViewModel(
    cdManager: .init(
      context: PersistenceController.preview.container.viewContext)
  )
  
  return VStack {
    ChartView(viewModel: viewModel)
      .frame(height: 300)
    
    /*
     Green Color: <CIColor 0x600000c52730 (0.203922 0.780392 0.34902 1) sRGB>
     Red Color: <CIColor 0x600000c62400 (1 0.231373 0.188235 1) sRGB>
     */
    VStack {
      Text("Red Color Values")
        .padding()
        .background(Color.red)
        .onAppear {
          // let red = UIColor(Color.red)
          // print("Red Color: \(CIColor(color: red))")
        }
      
      Text("Green Color Values")
        .padding()
        .background(Color.green)
        .onAppear {
          // let green = UIColor(Color.green)
          // print("Green Color: \(CIColor(color: green))")
        }
    }
  }
}
