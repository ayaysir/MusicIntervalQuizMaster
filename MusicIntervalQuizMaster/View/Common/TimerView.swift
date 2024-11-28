//
//  TimerView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/27/24.
//

import SwiftUI

struct TimerView: View {
  @Binding var remainingTime: Double
  let totalDuration: Double

  var body: some View {
    let progress = remainingTime / totalDuration
    let timerText = String(format: totalDuration == .zero ? "∞" : "%0.f", ceil(remainingTime))
    
    CircularProgressBar(progress: .constant(progress), text: .constant(timerText))
      .frame(width: 40)
  }
}
