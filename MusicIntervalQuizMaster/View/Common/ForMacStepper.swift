//
//  ForMacStepper.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/30/24.
//

import SwiftUI

// Stepper가 iOS 앱을 My Mac 에서 실행할 때 크래시 발생하는 문제
// https://forums.developer.apple.com/forums/thread/730554
struct ForMacStepper: View {
  @Binding var value: Int
  let range: ClosedRange<Int>
  let step: Int
  let label: () -> AnyView
  
  var body: some View {
    HStack {
      // 라벨 부분
      // Text("\(value)")
      label()
      Button("-") {
        if value > range.lowerBound {
          value -= step
        }
      }
      .buttonStyle(.bordered)
      Button("+") {
        if value < range.upperBound {
          value += step
        }
      }
      .buttonStyle(.bordered)
    }
  }
}

extension ForMacStepper {
  init(value: Binding<Int>, range: ClosedRange<Int>, step: Int, @ViewBuilder label: @escaping () -> some View) {
    self._value = value
    self.range = range
    self.step = step
    self.label = {
      AnyView(label()) // 클로저로 받은 뷰를 AnyView로 감싸서 반환
    }
  }
}
