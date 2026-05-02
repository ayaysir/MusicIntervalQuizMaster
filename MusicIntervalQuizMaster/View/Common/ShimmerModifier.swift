//
//  ShimmerModifier.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 5/2/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
  @State private var move = false
  
  func body(content: Content) -> some View {
    content
      .overlay(
        GeometryReader { geo in
          LinearGradient(
            colors: [
              .clear,
              .white.opacity(0.4),
              .clear
            ],
            startPoint: .top,
            endPoint: .bottom
          )
          .rotationEffect(.degrees(30))
          .blendMode(.screen)
          .offset(x: move ? geo.size.width : -geo.size.width)
          .animation(
            .linear(duration: 2)
            .repeatForever(autoreverses: false),
            value: move
          )
        }
      )
      .clipped()
      .onAppear {
        move = true
      }
  }
}

extension View {
  func shimmer() -> some View {
    self.modifier(ShimmerModifier())
  }
}

#Preview {
  MoreInfoView()
}
