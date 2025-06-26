//
//  TimerDomain.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 6/26/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TimerDomain {
  @ObservableState
  struct State: Equatable {
    var remainingTime: Double
    var totalDuration: Double
    var isRunning: Bool = false
    
    var progress: Double {
      totalDuration > 0 ? remainingTime / totalDuration : 0
    }
    var timerText: String {
      totalDuration == 0 ? "∞" : String(format: "%.0f", ceil(remainingTime))
    }
  }
  
  enum Action: Equatable {
    /// - `duration`: 총 시간
    case start(duration: Double)
    case reset(duration: Double)
    case tick
    case stop
    case expired
    case resume
  }
  
  enum CancelID {
    case timer
  }
  
  private func runTimer(for milliseconds: any BinaryInteger) -> Effect<Self.Action> {
    .run { send in // send: TimerDomain.Action
      while true {
        try await Task.sleep(for: .milliseconds(milliseconds))
        await send(.tick) // case: .tick 으로 이동
      }
    }
    // cancelInFlight: true를 주면 이전 타이머가 있으면 중단시키고 새로 시작합니다.
    .cancellable(id: CancelID.timer, cancelInFlight: true)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .start(duration: let duration):
        state.remainingTime = duration
        // state.totalDuration = duration
        state.isRunning = true
        
        return runTimer(for: 100)
      case .reset(duration: let duration):
        state.remainingTime = duration
        // state.totalDuration = duration
        state.isRunning = false
        return .none
      case .tick:
        guard state.isRunning else {
          return .none
        }
        
        state.remainingTime = max(0, state.remainingTime - 0.1)
        if state.remainingTime <= 0 {
          state.isRunning = false
          return .send(.expired) // // case: .expired 으로 이동
        }
        
        return .none
      case .stop:
        state.isRunning = false
        return .cancel(id: CancelID.timer)
      case .expired:
        return .cancel(id: CancelID.timer)
      case .resume:
        if !state.isRunning {
          state.isRunning = true
          return runTimer(for: 100)
        }
        
        return .none
      }
    }
  }
}
