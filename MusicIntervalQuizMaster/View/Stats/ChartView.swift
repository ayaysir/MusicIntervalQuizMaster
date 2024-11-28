//
//  ChartView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI
import Charts

struct SalesData: Identifiable {
  let id = UUID()
  let day: String
  let sales: Int
}

struct RegionSalesData: Identifiable {
  let id = UUID()
  let region: String
  let day: String
  let sales: Int
}

struct ChartView: View {
  let data = [
    SalesData(day: "Monday", sales: 150),
    SalesData(day: "Tuesday", sales: 200),
    SalesData(day: "Wednesday", sales: 170)
  ]
  
  let regionalData = [
    RegionSalesData(region: "North", day: "Monday", sales: 150),
    RegionSalesData(region: "South", day: "Monday", sales: 100),
    RegionSalesData(region: "North", day: "Tuesday", sales: 200),
    RegionSalesData(region: "South", day: "Tuesday", sales: 130),
  ]

  
  var body: some View {
    TabView {
      Group {
        Chart(data) { item in
          BarMark(
            x: .value("Day", item.day),
            y: .value("Sales", item.sales)
          )
        }
        .chartXAxis {
          AxisMarks(preset: .aligned) { value in
            AxisValueLabel()
            AxisTick()
          }
        }
        .chartYAxis {
          AxisMarks(preset: .extended)
        }
        
        Chart(regionalData) { item in
          BarMark(
            x: .value("Day", item.day),
            y: .value("Sales", item.sales)
          )
          .foregroundStyle(by: .value("Region", item.region))
        }
        
        Chart(data) { item in
          BarMark(
            x: .value("Day", item.day),
            y: .value("Sales", item.sales)
          )
        }
        
        Chart(data) { item in
          LineMark(
            x: .value("Day", item.day),
            y: .value("Sales", item.sales)
          )
        }
        
        Chart(data) { item in
          AreaMark(
            x: .value("Day", item.day),
            y: .value("Sales", item.sales)
          )
        }
        
        Chart(data) { item in
          PointMark(
            x: .value("Day", item.day),
            y: .value("Sales", item.sales)
          )
        }
      }
    }
    .tabViewStyle(.page)
    
    
  }
}

#Preview {
  ChartView()
    .frame(height: 200)
}
