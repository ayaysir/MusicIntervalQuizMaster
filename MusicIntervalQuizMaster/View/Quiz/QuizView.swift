//
//  ContentView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

struct QuizView: View {
  @Environment(\.scenePhase) var scenePhase
  @State private var isEnteredBackground = false
  
  @AppStorage(.cfgQuizSoundAutoplay) var cfgQuizSoundAutoplay = true
  @AppStorage(.cfgTimerSeconds) var cfgTimerSeconds = 0
  @AppStorage(.cfgQuizSheetPosition) var cfgQuizSheetPosition = 0
  
  @StateObject var viewModel = QuizViewModel()
  @StateObject var keyboardViewModel = IntervalTouchKeyboardViewModel()
  
  @State private var isMusiqwikViewPressed = false
  @State private var showAnswerAlert = false
  @State private var animateAlertDismiss = false
  @State private var offsetX: CGFloat = 0
  
  @State private var workItem: DispatchWorkItem?
  @State private var remainingTime: Double = 5
  @State private var timerActive: Bool = true
  @State private var timer: Timer?
  
  var body: some View {
    VStack {
      /*
       2 above: x o
       0 mid: o o
       1 below: o x
       */
      if cfgQuizSheetPosition == 0 || cfgQuizSheetPosition == 1 {
        Spacer()
      }
      
      headerView
      
      musiqwikView
      
      if cfgQuizSheetPosition == 0 || cfgQuizSheetPosition == 2 {
        Spacer()
      }
      
      HStack {
        Text("\(viewModel.answerText)")
          .font(.subheadline).bold()
          .frame(height: 40)
      }
      .frame(maxWidth: .infinity)
      .background(.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 5))
      .padding(.horizontal, 10)
      .opacity(viewModel.answerMode == .inQuiz ? 0 : 1)
      .animation(.easeInOut, value: viewModel.answerMode)
  
      Group {
        HStack {
          intervalTextField(
            "\(keyboardViewModel.intervalModifier.textFieldLocalizedDescription)",
            backgroundColor: .purple.opacity(0.4),
            isLeading: false
          )
          intervalTextField(
            "\(keyboardViewModel.intervalNumber)",
            backgroundColor: .cyan.opacity(0.4)
          )
        }
        
        IntervalTouchKeyboardView {
          pressEnterButton()
        }
        .environmentObject(keyboardViewModel)
        .disabled(showAnswerAlert)
        .foregroundColor(animateAlertDismiss ? .gray : nil)
        .contrast(animateAlertDismiss ? 0.9 : 1)
        .onChange(of: showAnswerAlert) { newValue in
          if newValue {
            withAnimation(.easeInOut(duration: 0.2)) {
              animateAlertDismiss = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1300)) {
              withAnimation(.easeInOut(duration: 0.2)) {
                showAnswerAlert = false
                animateAlertDismiss = false // 애니메이션 완료 후 상태 초기화
              }
            }
          }
        }
      }
      .padding(.horizontal, 10)
      .padding(.bottom, 10)
    }
    .alert(isPresent: $showAnswerAlert, view: customAlertView)
  }
  
  private var headerView: some View {
    HStack(spacing: 0) {
      currentSessionButton
      
      Spacer()
      
      TimerView(remainingTime: $remainingTime, totalDuration: Double(cfgTimerSeconds))
      
      Spacer()
      
      HStack(spacing: 5) {
        Button {
          cfgQuizSheetPosition = cfgQuizSheetPosition >= 2 ? 0 : cfgQuizSheetPosition + 1
        } label: {
          let imageName = cfgQuizSheetPosition == 0 ? "square.split.1x2.fill" : cfgQuizSheetPosition == 1 ? "square.bottomhalf.filled" : "square.tophalf.filled"
          Image(systemName: imageName)
            .foregroundStyle(.solidGray)
            .font(.system(size: 13))
            .frame(width: 20, height: 20)
        }
        .padding(5)
        .background(.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        
        Button {
          cfgQuizSoundAutoplay.toggle()
        } label: {
          HStack(spacing: 3) {
            Image(systemName: cfgQuizSoundAutoplay ? "speaker.wave.2.fill" : "speaker.fill")
              .frame(width: 15)
            Text("Auto")
          }
          .foregroundStyle(cfgQuizSoundAutoplay ? .blue : .gray)
            .font(.system(size: 13))
            .frame(width: 60, height: 20)
        }
        .padding(5)
        .background(.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
    }
    .padding(.horizontal, 10)
    .padding(.top, 20)
  }
  
  private var musiqwikView: some View {
    MusiqwikView(pair: viewModel.currentPair)
      // .frame(maxWidth: .infinity)
      .frame(height: 150)
      .scaleEffect(isMusiqwikViewPressed ? 0.965 : 1.0) // 눌렀을 때 살짝 작아짐
      .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isMusiqwikViewPressed) // 부드러운 애니메이션
      .offset(x: offsetX)
      .onAppear {
        if cfgQuizSoundAutoplay {
          playSounds()
        }
        
        if viewModel.answerMode == .inQuiz {
          invalidateTimer()
          startCountdown()
        }
        
        if isEnteredBackground {
          if viewModel.answerMode == .inQuiz {
            viewModel.preparePairData()
          }
          
          isEnteredBackground = false
        }
      }
      .onDisappear {
        if viewModel.answerMode == .inQuiz {
          invalidateTimer()
          
          // 새로운 세션 시작 (퀴즈중이라면)
          isEnteredBackground = true
        }
        
        stopSounds()
      }
      .onChange(of: scenePhase) { newPhase in
        switch newPhase {
        case .background:
          print("newPhase: background")
          isEnteredBackground = true
        case .inactive:
          print("newPhase: inactive")
        case .active:
          print("newPhase: isActive")
          if isEnteredBackground {
            if viewModel.answerMode == .inQuiz {
              viewModel.preparePairData()
            }
            
            isEnteredBackground = false
          }
        @unknown default:
          print("newPhase: unknown default")
        }
      }
      .onChange(of: viewModel.currentPair) { _ in
        if cfgQuizSoundAutoplay {
          playSounds()
        }
        
        invalidateTimer()
        startCountdown()
      }
      .onTapGesture {
        if store.bool(forKey: .cfgHapticPressedIntervalKeyboard) {
          HapticManager.rigid.vibrate()
        }
        HapticManager.soft.vibrate()
        
        isMusiqwikViewPressed = true
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
          isMusiqwikViewPressed = false
        }
        
        playSounds()
      }
      .gesture(
        DragGesture()
          .onChanged { value in
            // 드래그 중 감지
            offsetX = value.translation.width
          }
          .onEnded { value in
            // 드래그 완료 후 동작
            if value.translation.width > 50 {
              viewModel.prev()
              prevAnimation()
              comebackAnimation()
              
              keyboardViewModel.answerMode = viewModel.answerMode
            } else if value.translation.width < -50 {
              print(viewModel.isNextQuestionAlreadyAppeared, viewModel.answerMode, viewModel.isCurrentPairCountEqualLastMax)
              if viewModel.isNextQuestionAlreadyAppeared || (viewModel.answerMode == .correct && viewModel.isCurrentPairCountEqualLastMax) {
                
                viewModel.next()
                nextAnimation()
                comebackAnimation()
                
                keyboardViewModel.answerMode = viewModel.answerMode
              } else {
                comebackAnimation()
              }
            }
          }
      )
  }
  
  private var customAlertView: CustomAlertView {
    guard let interval = viewModel.currentPair.advancedInterval else {
      return CustomAlertView(
        title: "error_occurred".localized,
        subtitle: "out_of_range_interval".localized,
        icon: .error
      )
    }
    
    // 약어
    let title = viewModel.answerMode == .correct
    ? "\("correct_message".localized) \("interval_message".localizedFormat(interval.abbrDescription))"
    : "incorrect_message".localized
    // 정식 명칭
    let subtitle = viewModel.answerMode == .correct
    ? "message_correct_interval".localizedFormat(interval.localizedDescription)
    : "message_try_again".localized
    
    return CustomAlertView(
      title: title,
      subtitle: subtitle,
      icon: viewModel.answerMode == .correct ? .done : .error
    )
  }
}

// view와 관련된 변수들
extension QuizView {
  private func intervalTextField(_ text: String, backgroundColor: Color, isLeading: Bool = true) -> some View {
    Text(text == "0" ? "-" : text)
      .padding()
      .font(.system(size: 25).bold())
      .frame(height: 40, alignment: isLeading ? .leading : .trailing)
      .frame(maxWidth: .infinity)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 5))
  }
  
  private func prevAnimation(beforeOffsetX: CGFloat = -300, afterOffsetX: CGFloat = 200) {
    offsetX = beforeOffsetX
    withAnimation {
      offsetX = afterOffsetX
    }
  }
  
  private func nextAnimation(beforeOffsetX: CGFloat = 300, afterOffsetX: CGFloat = -200) {
    offsetX = beforeOffsetX
    withAnimation {
      offsetX = afterOffsetX
    }
  }
  
  private func comebackAnimation() {
    // 원래 위치로 돌아가기
    withAnimation(.easeOut(duration: 0.5)) {
      offsetX = 0
    }
  }
  
  private var currentSessionButton: some View {
    Menu {
      Button("new_session_start".localized) {
        // CoreData: 세션 생성
        viewModel.preparePairData()
      }

      Text("reset_current_record_and_start_new_session".localized)
        .font(.caption2)
    } label: {
      VStack(alignment: .leading) {
        Text("current_session".localized)
          .font(.system(size: 12))
          .bold()
        HStack {
          Text("✅ \(viewModel.answerCount)   ❌ \(viewModel.wrongCount)   (\(viewModel.answerPercentText))")
        }
        .font(.system(size: 10))
      }
      .foregroundStyle(.foreground)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .frame(width: 120, alignment: .leading)
      // .frame(maxWidth: .infinity)
      .background(.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }
}

extension QuizView {
  private func stopSounds() {
    SoundManager.shared.stopAllSounds()
    
    if let workItem {
      workItem.cancel()
    }
  }
  
  private func playSounds() {
    stopSounds()
    
    workItem = .init {
      viewModel.currentPair.endNote.playSound()
    }
    
    switch viewModel.currentPair.direction {
    case .ascending, .descending:
      viewModel.currentPair.startNote.playSound()
      if let workItem {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200), execute: workItem)
      }
    case .simultaneously:
      viewModel.currentPair.startNote.playSound()
      viewModel.currentPair.endNote.playSound()
    }
  }
  
  private func checkAnswer(forceWrong: Bool = false) {
    guard keyboardViewModel.intervalNumber != 0 || forceWrong  else {
      HapticManager.warning.vibrate()
      return
    }
    
    invalidateTimer()
    showAnswerAlert = true
    
    let isCorrect = viewModel.checkAnswer(keyboardViewModel.intervalModifier, keyboardViewModel.intervalNumber)
    
    // 정답 처리는 viewModel.checkAnswer() 가 함
    
    if isCorrect {
      if store.bool(forKey: .cfgHapticAnswer) {
        HapticManager.success.vibrate()
      }
      
      if store.bool(forKey: .cfgAppAutoNextMove) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1301)) {
          showAnswerAlert = false
          goNextQuestion()
        }
      }
      
    } else {
      setWrong()
    }
    
    keyboardViewModel.answerMode = viewModel.answerMode
  }
  
  private func setWrong() {
    keyboardViewModel.answerMode = viewModel.answerMode
    
    if store.bool(forKey: .cfgHapticWrong) {
      HapticManager.warning.vibrate()
    }
  }
  
  private func goNextQuestion() {
    if store.bool(forKey: .cfgHapticPressedIntervalKeyboard) {
      HapticManager.rigid.vibrate()
    }
    
    viewModel.next()
    nextAnimation(afterOffsetX: -350)
    comebackAnimation()
    keyboardViewModel.intervalNumber = 0
    keyboardViewModel.answerMode = viewModel.answerMode
    
  }
  
  private func pressEnterButton() {
    if viewModel.answerMode == .inQuiz {
      checkAnswer()
    } else {
      if viewModel.answerMode == .correct {
        goNextQuestion()
      } else {
        checkAnswer()
      }
    }
  }
  
  private func startCountdown() {
    guard cfgTimerSeconds > 0 else {
      return
    }
    
    remainingTime = Double(cfgTimerSeconds)
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
      if remainingTime > 0 {
        remainingTime = max(remainingTime - 0.1, 0)
      } else {
        invalidateTimer()
        
        performActionAfterCountdown()
      }
    }
  }
  
  private func invalidateTimer() {
    timer?.invalidate()
    remainingTime = 0
    withAnimation {
      timerActive = false
    }
  }

  private func performActionAfterCountdown() {
    // 5초 후 실행할 작업
    // print("카운트다운 완료, 작업 실행!")
    // playSounds()
    checkAnswer(forceWrong: true)
  }
}

#Preview {
  // QuizView(viewModel: .init(cdManager: nil))
  MainTabBarView()
}
