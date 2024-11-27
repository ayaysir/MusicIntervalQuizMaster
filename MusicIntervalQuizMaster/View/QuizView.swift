//
//  ContentView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

struct QuizView: View {
  @AppStorage(.cfgQuizSoundAutoplay) var cfgQuizSoundAutoplay = true
  
  @StateObject var viewModel = QuizViewModel()
  @StateObject var keyboardViewModel = IntervalTouchKeyboardViewModel()
  
  @State private var workItem: DispatchWorkItem?
  @State private var isMusiqwikViewPressed = false
  @State private var showAnswerAlert = false
  @State private var animateAlertDismiss = false
  @State private var offsetX: CGFloat = 0
  
  enum CurrentAnswerMode {
    case inQuiz, correct, wrong
  }
  @State private var currentAnswerMode: CurrentAnswerMode = .inQuiz
  
  private func intervalTextField(_ text: String, backgroundColor: Color, isLeading: Bool = true) -> some View {
    Text(text == "0" ? "-" : text)
      .padding()
      .font(.system(size: 25).bold())
      .frame(height: 50, alignment: isLeading ? .leading : .trailing)
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
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        VStack(alignment: .leading) {
          Text("Current Session:")
            .font(.system(size: 14))
            .bold()
          Text("✅ \(viewModel.answerCount)   ❌ \(viewModel.wrongCount)")
            .font(.system(size: 12))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .frame(width: 135, alignment: .leading)
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        
        
        Spacer()
        Button {
          cfgQuizSoundAutoplay.toggle()
        } label: {
          Label("Auto Play \(cfgQuizSoundAutoplay ? "ON" : "OFF")", systemImage: cfgQuizSoundAutoplay ? "speaker.wave.2.fill" : "speaker.fill")
            .foregroundStyle(cfgQuizSoundAutoplay ? .blue : .gray)
            .font(.system(size: 14))
        }
      }
      .padding()
      
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
        }
        .onChange(of: viewModel.currentPair) { _ in
          if cfgQuizSoundAutoplay {
            playSounds()
          }
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
                viewModel.prev()
                prevAnimation()
              } else if value.translation.width < -50 {
                viewModel.next()
                nextAnimation()
              }
              
              comebackAndToggleButtonImage()
            }
        )
      
      // Text("Count: \(viewModel.currentPairCount)")
      // Text(viewModel.currentPair.description)
      //   .font(.footnote)
      let answerText = switch currentAnswerMode {
      case .inQuiz:
        "🤔"
      case .correct:
        "✅ 맞았습니다. (\(viewModel.currentPair.advancedInterval?.description ?? ""))"
      case .wrong:
        "❌ 틀렸습니다. 눌러서 힌트 보기"
      }
      
      HStack {
        Text("\(answerText)")
          .font(.caption)
          .frame(height: 30)
          .frame(maxWidth: .infinity)
          .background(.gray.opacity(0.3))
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .padding(.horizontal, 10)
          .opacity(currentAnswerMode == .inQuiz ? 0 : 1)
          .animation(.easeInOut, value: currentAnswerMode)
        
          // Button {
          //   viewModel.prev()
          //   prevAnimation()
          //   comebackAndToggleButtonImage()
          // } label: {
          //   Text("<")
          // }
          // Button {
          //   viewModel.next()
          //   nextAnimation(afterOffsetX: -350)
          //   comebackAndToggleButtonImage()
          // } label: {
          //   Text(">")
          // }
      }
  
      Group {
        HStack {
          intervalTextField(
            "\(keyboardViewModel.intervalModifier)",
            backgroundColor: .red.opacity(0.5),
            isLeading: false
          )
          intervalTextField(
            "\(keyboardViewModel.intervalNumber)",
            backgroundColor: .cyan.opacity(0.5)
          )
        }
        
        IntervalTouchKeyboardView {
          withAnimation {
            pressEnterButton()
          }
        }
        .environmentObject(keyboardViewModel)
        .disabled(showAnswerAlert)
        .foregroundColor(animateAlertDismiss ? .gray : nil)
        .contrast(animateAlertDismiss ? 0.9 : 1)
        // .foregroundStyle(showAnswerAlert ? .gray : nil)
        .onChange(of: showAnswerAlert) { newValue in
          if newValue {
            withAnimation {
              animateAlertDismiss = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1400)) {
              withAnimation {
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
    let intervalDescription = viewModel.currentPair.advancedInterval?.description ?? ""
    // 약어
    let title = currentAnswerMode == .correct 
    ? "맞았습니다. \(intervalDescription) 입니다."
    : "틀렸습니다."
    // 정식 명칭
    let subtitle = currentAnswerMode == .correct
    ? "해당 음정은 \(intervalDescription) 입니다."
    : "다시 한 번 풀어보세요."
    
    return CustomAlertView(
      title: title,
      subtitle: subtitle,
      icon: currentAnswerMode == .correct ? .done : .error
    )
  }
  
  private func playSounds() {
    SoundManager.shared.stopAllSounds()
    SoundManager.shared.cleanupFinishedPlayers()
    
    if let workItem {
      workItem.cancel()
    }
    
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
  
  private func comebackAndToggleButtonImage() {
    comebackAnimation()
    currentAnswerMode = .inQuiz
    keyboardViewModel.enterButtonMode = .inQuiz
  }
  
  private func checkAnswer() {
    guard keyboardViewModel.intervalNumber != 0 else {
      HapticMananger.warning.vibrate()
      return
    }
    
    showAnswerAlert = true
    
    if let currentPairDescrition = viewModel.currentPair.advancedInterval?.description {
      if keyboardViewModel.intervalAbbrDescription == currentPairDescrition {
        // 정답인 경우
        currentAnswerMode = .correct
        keyboardViewModel.enterButtonMode = .viewAnswer
        
        viewModel.appendAnswerCount(isCorrect: true)
        
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
        // 오답인 경우
        currentAnswerMode = .wrong
        viewModel.appendAnswerCount(isCorrect: false)
        
        if store.bool(forKey: .cfgHapticWrong) {
          HapticMananger.warning.vibrate()
        }
      }
    }
  }
  
  private func goNextQuestion() {
    viewModel.next()
    nextAnimation(afterOffsetX: -350)
    comebackAndToggleButtonImage()
    keyboardViewModel.intervalNumber = 0
  }
  
  private func pressEnterButton() {
    if keyboardViewModel.enterButtonMode == .inQuiz {
      playSounds()
      checkAnswer()
    } else {
      if currentAnswerMode == .correct {
        goNextQuestion()
      } else {
        playSounds()
        checkAnswer()
      }
    }
  }
}

#Preview {
  QuizView()
}
