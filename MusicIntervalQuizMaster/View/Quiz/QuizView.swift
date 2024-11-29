//
//  ContentView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

struct QuizView: View {
  @AppStorage(.cfgQuizSoundAutoplay) var cfgQuizSoundAutoplay = true
  @AppStorage(.cfgTimerSeconds) var cfgTimerSeconds = 0
  
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
  
  var recordHelper = QuestionRecordEntityCreateHelper()
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        currentSessionButton
        
        Spacer()
        
        TimerView(remainingTime: $remainingTime, totalDuration: Double(cfgTimerSeconds))
        
        Spacer()
        
        Button {
          cfgQuizSoundAutoplay.toggle()
        } label: {
          Label("Auto Sound", systemImage: cfgQuizSoundAutoplay ? "speaker.wave.2.fill" : "speaker.fill")
            .foregroundStyle(cfgQuizSoundAutoplay ? .blue : .gray)
            .font(.system(size: 14))
        }
      }
      .padding(.horizontal, 10)
      
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
          
          if viewModel.currentAnswerMode == .inQuiz {
            invalidateTimer()
            startCountdown()
            
            // recordStep1()
          }
        }
        .onDisappear {
          if viewModel.currentAnswerMode == .inQuiz {
            invalidateTimer()
            setWrong()
          }
          
          stopSounds()
        }
        .onChange(of: viewModel.currentPair) { _ in
          if cfgQuizSoundAutoplay {
            playSounds()
          }
          
          invalidateTimer()
          startCountdown()
          
          // recordStep1()
        }
        .onTapGesture {
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
                viewModel.currentAnswerMode = .inQuiz
                keyboardViewModel.enterButtonMode = .inQuiz
                
                viewModel.prev()
                prevAnimation()
                comebackAnimation()
              } else if value.translation.width < -50 {
                if viewModel.isNextQuestionAlreadyAppeared || (viewModel.currentAnswerMode == .correct && viewModel.isCurrentPairCountEqualLastMax) {
                  viewModel.currentAnswerMode = .inQuiz
                  keyboardViewModel.enterButtonMode = .inQuiz
                  
                  viewModel.next()
                  nextAnimation()
                  comebackAnimation()
                } else {
                  comebackAnimation()
                }
              }
            }
        )
      
      HStack {
        Text("\(viewModel.answerText)")
          .font(.subheadline).bold()
          .frame(height: 40)
      }
      .frame(maxWidth: .infinity)
      .background(.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 5))
      .padding(.horizontal, 10)
      .opacity(viewModel.currentAnswerMode == .inQuiz ? 0 : 1)
      .animation(.easeInOut, value: viewModel.currentAnswerMode)
  
      Group {
        HStack {
          intervalTextField(
            "\(keyboardViewModel.intervalModifier.textFieldLocalizedDescription)",
            backgroundColor: .red.opacity(0.5),
            isLeading: false
          )
          intervalTextField(
            "\(keyboardViewModel.intervalNumber)",
            backgroundColor: .cyan.opacity(0.5)
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
  
  private var customAlertView: CustomAlertView {
    guard let interval = viewModel.currentPair.advancedInterval else {
      return CustomAlertView(
        title: "에러가 발생했습니다.",
        subtitle: "학습 범위를 넘어서는 음정입니다.",
        icon: .error
      )
    }
    
    // 약어
    let title = viewModel.currentAnswerMode == .correct
    ? "맞았습니다. \(interval.abbrDescription) 입니다."
    : "틀렸습니다."
    // 정식 명칭
    let subtitle = viewModel.currentAnswerMode == .correct
    ? "해당 음정은 \(interval.localizedDescription) 입니다. "
    : "다시 한 번 풀어보세요."
    
    return CustomAlertView(
      title: title,
      subtitle: subtitle,
      icon: viewModel.currentAnswerMode == .correct ? .done : .error
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
    if viewModel.currentPairCount != 0 {
      offsetX = beforeOffsetX
      withAnimation {
        offsetX = afterOffsetX
      }
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
      Button("새로운 세션 시작") {
        recordHelper.createNewSession()
        recordHelper.createNewRecordEntity()
        viewModel.preparePairData()
      }
      Text("현재 기록을 초기화하고 새로운 세션을 시작합니다.")
        .font(.caption2)
    } label: {
      VStack(alignment: .leading) {
        Text("Current Session:")
          .font(.system(size: 14))
          .bold()
        Text("✅ \(viewModel.answerCount)   ❌ \(viewModel.wrongCount)")
          .font(.system(size: 12))
      }
      .foregroundStyle(.foreground)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .frame(width: 135, alignment: .leading)
      .background(.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }
}

extension QuizView {
  private func stopSounds() {
    SoundManager.shared.stopAllSounds()
    SoundManager.shared.cleanupFinishedPlayers()
    
    if let workItem {
      workItem.cancel()
    }
  }
  
  private func playSounds() {
    stopSounds()
    
    workItem = .init {
      viewModel.currentPair.endNote.playSound()
    }
    
    switch viewModel.currentPair.category {
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
  
  private func checkAnswer() {
    guard keyboardViewModel.intervalNumber != 0 else {
      HapticMananger.warning.vibrate()
      return
    }
    
    invalidateTimer()
    showAnswerAlert = true
    
    viewModel.currentTryCount += 1
    
    if let currentPairDescrition = viewModel.currentPair.advancedInterval?.abbrDescription {
      if keyboardViewModel.intervalAbbrDescription == currentPairDescrition {
        // 정답인 경우
        viewModel.currentAnswerMode = .correct
        keyboardViewModel.enterButtonMode = .viewAnswer
        
        viewModel.appendAnswerCount(isCorrect: true)
        
        // if !isReachedFirstAnswer {
        //   if currentTryCount > 1,
        //      currentAnswerMode == .correct {
        //     // record step 3: 마지막 시도
        //     recordHelper.create_step3_whenWrongFirstTryAndFinallyAnswered(
        //       finalAnswerTime: .now,
        //       tryCount: Int16(currentTryCount)
        //     )
        //   }
        //   
        //   isReachedFirstAnswer = true
        // }
        
        if store.bool(forKey: .cfgHapticAnswer) {
          HapticMananger.success.vibrate()
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
    }
    
    // if currentTryCount == 1,
    //    let myInterval = viewModel.currentPair.advancedInterval {
    //   // record step 2: 최초 시도
    //   recordHelper.create_step2_afterFirstTry(
    //     firstTryTime: .now,
    //     isCorrect: currentAnswerMode == .correct,
    //     myInterval: myInterval
    //   )
    // }
  }
  
  private func setWrong() {
    // 오답인 경우
    viewModel.currentAnswerMode = .wrong
    viewModel.appendAnswerCount(isCorrect: false)
    
    if store.bool(forKey: .cfgHapticWrong) {
      HapticMananger.warning.vibrate()
    }
  }
  
  private func goNextQuestion() {
    viewModel.currentAnswerMode = .inQuiz
    keyboardViewModel.enterButtonMode = .inQuiz
    
    viewModel.next()
    nextAnimation(afterOffsetX: -350)
    comebackAnimation()
    keyboardViewModel.intervalNumber = 0
    // isReachedFirstAnswer = false
    viewModel.currentTryCount = 0
  }
  
  private func pressEnterButton() {
    if keyboardViewModel.enterButtonMode == .inQuiz {
      checkAnswer()
    } else {
      if viewModel.currentAnswerMode == .correct {
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
    
    // timerText = "\(cfgTimerSeconds)"
    remainingTime = Double(cfgTimerSeconds)
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
      if remainingTime > 0 {
        withAnimation {
          remainingTime = max(remainingTime - 0.1, 0)
        }
      } else {
        invalidateTimer()
        
        performActionAfterCountdown()
      }
    }
  }
  
  private func invalidateTimer() {
    timer?.invalidate()
    // timerProgress = 0
    // timerText = "-"
    remainingTime = 0
    withAnimation {
      timerActive = false
    }
  }

  private func performActionAfterCountdown() {
    // 5초 후 실행할 작업
    // print("카운트다운 완료, 작업 실행!")
    // playSounds()
    showAnswerAlert = true
    setWrong()
  }
  
  private func recordStep1() {
    guard viewModel.currentPairIsNotSolved else {
      return
    }
    // record step 1: 시작할 때
    let currentPair = viewModel.currentPair
    
    recordHelper.create_step1_afterOnAppear(
      direction: currentPair.category,
      clef: currentPair.clef,
      startTime: .now,
      startNote: currentPair.startNote,
      endNote: currentPair.endNote
    )
  }
}

#Preview {
  QuizView(recordHelper: .init(isForPreview: true))
}
