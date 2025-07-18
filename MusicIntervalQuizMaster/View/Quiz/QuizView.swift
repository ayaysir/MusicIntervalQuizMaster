//
//  ContentView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI

struct QuizView: View {
  // MARK: - View Main
  
  @Environment(\.scenePhase) var scenePhase
  @State private var isEnteredBackground = false
  
  @StateObject var viewModel = QuizViewModel()
  @ObservedObject var keyboardViewModel = IntervalTouchKeyboardViewModel()
  
  @AppStorage(.cfgQuizSoundAutoplay) var cfgQuizSoundAutoplay = true
  @AppStorage(.cfgTimerSeconds) var cfgTimerSeconds = 0
  @AppStorage(.cfgQuizSheetPosition) var cfgQuizSheetPosition = 0
  
  @State private var isMusiqwikViewPressed = false
  @State private var showAnswerAlert = false
  @State private var showQuizSettingSheet = false
  @State private var showRestartSessionAlert = false
  @State private var animateAlertDismiss = false
  @State private var showNewSessionAlert = false
  @State private var showInfoModal = false
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
      
      HeaderArea
      
      MusiqwikViewArea
      
      if cfgQuizSheetPosition == 0 || cfgQuizSheetPosition == 2 {
        Spacer()
      }
      
      HStack(spacing: 5) {
        QuizSettingButtonArea
        AnswerStatusArea
      }
     
      BottomKeyArea
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
    .onChange(of: viewModel.sessionCreated) { _ in
      showNewSessionAlert = true
    }
    .onChange(of: showAnswerAlert) { isShow in
      if isShow {
        withAnimation(.easeInOut(duration: 0.2)) {
          animateAlertDismiss = true
        }
        
        DispatchQueue.main.asyncAfter(
          deadline: .now() + .milliseconds(1300)
        ) {
          withAnimation(.easeInOut(duration: 0.2)) {
            showAnswerAlert = false
            animateAlertDismiss = false // 애니메이션 완료 후 상태 초기화
          }
        }
      }
    }
    .onReceive(keyboardViewModel.objectWillChange) { output in
      if showNewSessionAlert {
        showNewSessionAlert = false
      }
    }
    .alert(isPresent: $showAnswerAlert, view: answerAlertView)
    .alert(isPresent: $showNewSessionAlert, view: newSessionAlertView)
    .alert(
      "loc.quiz_settings_changed",
      isPresented: $showRestartSessionAlert,
      actions: {
        Button(role: .cancel) {} label: {
          Text("loc.continue_current_session")
        }
        Button("loc.start_new_session") {
          viewModel.preparePairData()
        }
      },
      message: {
      Text("loc.quiz_setting_change_warning")
    })
    .sheet(isPresented: $showInfoModal) {
      IntervalInfoView(pair: viewModel.currentPair)
    }
    .sheet(isPresented: $showQuizSettingSheet) {
      // on Dismiss
      showRestartSessionAlert = true
    } content: {
      ShrinkedQuizSettingView()
    }
  }
}

extension QuizView {
  // MARK: - View segments
  
  private var HeaderArea: some View {
    HStack(spacing: 0) {
      SessionMenu
      
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
  
  private var MusiqwikViewArea: some View {
    MusiqwikView(pair: viewModel.currentPair)
    // .frame(maxWidth: .infinity)
      .frame(height: 100)
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
        
        print(viewModel.sessionCreated)
        if viewModel.sessionCreated <= 1 && viewModel.answerMode == .inQuiz {
          showNewSessionAlert = true
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
      .gesture(musiqwikDragGesture)
  }
  
  private var QuizSettingButtonArea: some View {
    Button {
      showQuizSettingSheet.toggle()
    } label: {
      Image(systemName: "slider.horizontal.3")
        .foregroundStyle(Color.frontLabel)
        .font(.system(size: 15, weight: .bold))
        .frame(width: 40, height: 40)
        .background(Color.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    .padding(.leading, 10)
  }
  
  private var AnswerStatusArea: some View {
    // 상태창
    HStack(alignment: .center) {
      Text("\(viewModel.answerText)")
        .font(.subheadline).bold()
        .frame(height: 40)
      if viewModel.answerMode == .correct {
        Button {
          showInfoModal = true
        } label: {
          if #available(iOS 18.0, *) {
            Image(systemName: "text.page.badge.magnifyingglass")
              .foregroundStyle(Color.teal)
              .font(.system(size: 13))
              .bold()
          } else {
            Image(systemName: "doc.text.magnifyingglass")
              .foregroundStyle(Color.teal)
              .font(.system(size: 13))
              .bold()
          }
        }
      }
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.2))
    .clipShape(RoundedRectangle(cornerRadius: 5))
    .padding(.trailing, 10)
    .opacity(viewModel.answerMode == .inQuiz ? 0 : 1)
    .animation(.easeInOut, value: viewModel.answerMode)
  }
  
  private var BottomKeyArea: some View {
    VStack {
      BottomKeyPressStatusArea
      BottomKeyPadArea
    }
    .padding(.horizontal, 10)
    .padding(.bottom, 10)
  }
  
  private var BottomKeyPressStatusArea: some View {
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
  }
  
  private var BottomKeyPadArea: some View {
    IntervalTouchKeyboardView(keyboardViewModel: keyboardViewModel) {
      pressEnterButton()
    }
    .disabled(showAnswerAlert)
    .foregroundColor(animateAlertDismiss ? .gray : nil)
    .contrast(animateAlertDismiss ? 0.9 : 1)
    
  }
  
  private var SessionMenu: some View {
    Menu {
      Button("new_session_start".localized) {
        // CoreData: 세션 생성
        viewModel.preparePairData()
      }
      
      Text("reset_current_record_and_start_new_session".localized)
        .font(.system(size: 12))
    } label: {
      VStack(alignment: .leading) {
        Text(verbatim: "\("current_session".localized) (\(viewModel.answerPercentText))")
          .font(.system(size: 12))
          .bold()
          .lineLimit(1)
        Text("✅ \(viewModel.answerCount)   ❌ \(viewModel.wrongCount)")
          .lineLimit(1)
          .font(.system(size: 10))
      }
      .foregroundStyle(.foreground)
      .padding(.horizontal, 4)
      .padding(.vertical, 4)
      .frame(width: 110, alignment: .leading)
      .minimumScaleFactor(0.5)
      .background(.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 5))
    }
  }
  
  // MARK: - AlertView segments
  
  private var answerAlertView: CenterAlertView {
    guard let interval = viewModel.currentPair.advancedInterval else {
      return CenterAlertView(
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
    
    return CenterAlertView(
      title: title,
      subtitle: subtitle,
      icon: viewModel.answerMode == .correct ? .done : .error
    )
  }
  
  private var newSessionAlertView: BottomAlertView {
    return BottomAlertView(
      title: "new_session_start".localized,
      subtitle: nil,
      icon: .custom(.init(systemName: "newspaper")!)
    )
  }
  
  // MARK: - Drag Gestures
  
  private var musiqwikDragGesture: some Gesture {
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
  }
}

extension QuizView {
  
  // MARK: - View assistants
  
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
}

extension QuizView {
  // MARK: - Other funcs
  
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
    
    let qos = DispatchQoS.QoSClass.userInitiated
    
    switch viewModel.currentPair.direction {
    case .ascending, .descending:
      DispatchQueue.global(qos: qos).async {
        viewModel.currentPair.startNote.playSound()
      }
      
      if let workItem {
        DispatchQueue.global(qos: qos).asyncAfter(
          deadline: .now() + .milliseconds(1200),
          execute: workItem
        )
      }
    case .simultaneously:
      DispatchQueue.global(qos: qos).async {
        viewModel.currentPair.startNote.playSound()
        viewModel.currentPair.endNote.playSound()
      }
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
  MainTabBarView()
}
