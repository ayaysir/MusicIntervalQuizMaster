//
//  TimerView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/27/24.
//

import SwiftUI
import ComposableArchitecture

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

struct TimerCircleView: View {
  let store: StoreOf<TimerDomain>
  let onExpire: () -> Void
  
  var body: some View {
    WithPerceptionTracking {
      CircularProgressBar(
        progress: .constant(store.progress),
        text: .constant(store.timerText)
      )
      .frame(width: 40)
      .onAppear {
        if !store.isRunning {
          store.send(.start(duration: store.remainingTime))
        }
      }
      .onChange(of: store.remainingTime) { newValue in
        if newValue <= 0 {
          onExpire()
        }
      }
    }
  }
}

#Preview {
  let store = Store(
    initialState: TimerDomain.State(
      remainingTime: 7,
      totalDuration: 10,
      isRunning: false
    ),
    reducer: { TimerDomain() }
  )
  
  WithPerceptionTracking {
    VStack {
      Text(store.progress.description)
      
      TimerCircleView(store: store) {
        print("done.")
      }
      
      Button("9s") {
        store.send(.start(duration: 9))
      }
      
      Button("15s") {
        store.send(.reset(duration: 15))
      }
      
      Button("stop") {
        store.send(.stop)
      }
      
      Button("resume") {
        store.send(.resume)
      }
    }
  }
}
