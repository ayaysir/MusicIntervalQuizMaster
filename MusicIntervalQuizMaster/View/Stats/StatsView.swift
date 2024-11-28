//
//  StatsView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct StatsView: View {
  // 샘플 데이터
  let items = Array(1...20)
  
  // 두 개의 열을 가진 Grid 설정
  let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]
  
  var body: some View {
    VStack {
      ChartView()
        .padding(.horizontal, 10)
        .frame(height: 200)
      // Spacer()
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(items, id: \.self) { item in
            Text("Item \(item)")
              .frame(height: 100)
              .frame(maxWidth: .infinity)
              .background(Color.gray)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
        }
        .padding(10) // Grid 전체 패딩
      }
    }
  }
}

#Preview {
  StatsView()
}
