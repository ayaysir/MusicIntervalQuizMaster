//
//  EmbossedButtonStyle.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/24/24.
//

import SwiftUI

struct EmbossedButtonStyle: ButtonStyle {
  var pressedBorderColor: Color = .red
  var backgroundColor: Color = .intervalButtonBackground
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.vertical, 5)
      .background(
        ZStack {
          // 아래 그림자 (눌렀을 때 변화 강조)
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .shadow(
              color: configuration.isPressed ? .intervalButtonBackShadow.opacity(0.3) : .intervalButtonBackShadow.opacity(0.5),
              radius: configuration.isPressed ? 2 : 5,
              x: configuration.isPressed ? 1 : 3,
              y: configuration.isPressed ? 1 : 3
            )
          
          // 위 그림자 (눌렀을 때 변화 강조)
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.intervalButtonUpperShadow)
            .shadow(
              color: configuration.isPressed ? .intervalButtonFrontShadow.opacity(0.5) : .intervalButtonFrontShadow.opacity(0.8),
              radius: configuration.isPressed ? 1 : 5,
              x: configuration.isPressed ? -1 : -3,
              y: configuration.isPressed ? -1 : -3
            )
          
          // 버튼 배경
          RoundedRectangle(cornerRadius: 10)
            .fill(LinearGradient(
              gradient: Gradient(colors: [
                configuration.isPressed ? backgroundColor.opacity(0.9) : backgroundColor.opacity(0.7),
                configuration.isPressed ? backgroundColor.opacity(0.6) : backgroundColor
              ]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ))
        }
      )
      .overlay(
        // 테두리
        RoundedRectangle(cornerRadius: 10)
          .stroke(configuration.isPressed ? pressedBorderColor : .intervalButtonBorder, lineWidth: configuration.isPressed ? 2 : 1)
      )
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // 클릭 시 축소 효과 강조
  }
}

#Preview {
  IntervalTouchKeyboardView()
    .environmentObject(IntervalTouchKeyboardViewModel())
}
