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
  @State private var answerMessage: String = ""
  @State private var isMusiqwikViewPressed = false
  
  @State private var offsetX: CGFloat = 0
  
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
        .frame(maxWidth: .infinity)
        .scaleEffect(isMusiqwikViewPressed ? 0.965 : 1.0) // 눌렀을 때 살짝 작아짐
        .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isMusiqwikViewPressed) // 부드러운 애니메이션
        .offset(x: offsetX)
        .onAppear {
          if cfgQuizSoundAutoplay {
            initDataAndPlaySounds()
          }
        }
        .onChange(of: viewModel.currentPair) { _ in
          if cfgQuizSoundAutoplay {
            initDataAndPlaySounds()
          }
        }
        .onTapGesture {
          isMusiqwikViewPressed = true
          DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
            isMusiqwikViewPressed = false
          }
          
          initDataAndPlaySounds()
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
              
              comebackAnimation()
            }
        )
      
      Text("Count: \(viewModel.currentPairCount)")
      Text(viewModel.currentPair.description)
        .font(.footnote)
      Text(answerMessage)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.3))
      
      HStack {
        Button {
          viewModel.prev()
          prevAnimation()
          comebackAnimation()
        } label: {
          Text("prev")
        }
        Button {
          viewModel.next()
          nextAnimation(afterOffsetX: -350)
          comebackAnimation()
        } label: {
          Text("next")
        }
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
          initDataAndPlaySounds()
          
          if let currentPairDescrition = viewModel.currentPair.advancedInterval?.description {
            if keyboardViewModel.intervalAbbrDescription == currentPairDescrition {
              answerMessage = "✅ 맞았습니다. (\(keyboardViewModel.intervalAbbrDescription))"
            } else {
              answerMessage = "❌ 틀렸습니다. (\(keyboardViewModel.intervalAbbrDescription))"
            }
          }
        }
        .environmentObject(keyboardViewModel)
      }
      .padding(.horizontal, 10)
      .padding(.bottom, 10)
    }
  }
  
  private func initDataAndPlaySounds() {
    answerMessage = ""
    
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
}

#Preview {
  QuizView()
}
