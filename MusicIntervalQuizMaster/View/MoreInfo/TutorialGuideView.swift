//
//  TutorialGuideView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct TutorialGuideView: View {
  @State private var currentIndex: Int = 0
  private let contentCount = 5 // 총 콘텐츠 개수
  @State private var dragOffset: CGFloat = 0
  
  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        ForEach(0..<contentCount, id: \.self) { index in
          InnerContentView(index: index)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
      }
      .offset(y: -CGFloat(currentIndex) * proxy.size.height + dragOffset)
      .gesture(
        DragGesture()
          .onChanged {
            dragOffset = $0.translation.height
          }
          .onEnded { value in
            let threshold = proxy.size.height / 3 // 전환 임계값
            
            if value.translation.height < -threshold, currentIndex < contentCount - 1 {
              // 위로 스와이프 - 다음 콘텐츠로 이동
              currentIndex += 1
            } else if value.translation.height > threshold, currentIndex > 0 {
              // 아래로 스와이프 - 이전 콘텐츠로 이동
              currentIndex -= 1
            }
            // 드래그 종료 후 위치 초기화
            dragOffset = 0
          }
      )      .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5), value: currentIndex)
    }
    .ignoresSafeArea()
  }
}

struct InnerContentView: View {
  let index: Int
  
  var body: some View {
    ZStack {
      Color(hue: Double(index) / 10.0, saturation: 0.8, brightness: 0.9)
        .ignoresSafeArea()
      Text("콘텐츠 \(index + 1)")
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundColor(.white)
    }
  }
}


#Preview {
  TutorialGuideView()
}
