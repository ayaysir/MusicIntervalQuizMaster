//
//  CircularProgressBar.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/27/24.
//

import SwiftUI

struct CircularProgressBar: View {
  @Binding var progress: Double // 0.0 ~ 1.0
  @Binding var text: String
  
  @State private var progressText = ""
  
  let lineWidth: CGFloat = 5
  
  var body: some View {
    ZStack {
      // 배경 원
      Circle()
        .stroke(lineWidth: lineWidth)
        .opacity(0.2)
        .foregroundColor(Color.gray)
      
      // 진행 원
      Circle()
        .trim(from: 0.0, to: progress)
        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        .foregroundColor(Color.teal)
        .rotationEffect(.degrees(-90)) // 시작점을 위로 이동
        .scaleEffect(x: -1, y: 1) // X축 반전
        // .animation(.linear(duration: 0.1), value: progress)
      
      // 중앙 텍스트
      Text(text.isEmpty ? progressText : text)
        .font(.footnote)
        .bold()
        .foregroundColor(.solidGray)
    }
    .onChange(of: progress) { newValue in
      progressText = String(format: "%.0f", newValue * 100)
    }
  }
}

#Preview {
  CircularProgressBar(progress: .constant(0.7), text: .constant("10"))
    .padding(10)
}
