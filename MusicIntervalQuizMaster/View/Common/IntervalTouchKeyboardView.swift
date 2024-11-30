//
//  IntervalTouchKeyboardView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import SwiftUI

struct IntervalTouchKeyboardView: View {
  @EnvironmentObject var keyboardViewModel: IntervalTouchKeyboardViewModel
  @AppStorage(.cfgHapticPressedIntervalKeyboard) var isHaptic = false
  
  let enterAction: (() -> Void)?
  
  init(enterAction: (() -> Void)? = nil) {
    self.enterAction = enterAction
  }
  
  private func vibrate() {
    if isHaptic {
      HapticManager.rigid.vibrate()
    }
  }
  
  private func internalButtonText(_ title: String, color: Color = .intervalButtonBackground) -> some View {
    Text(title)
      .frame(height: 50)
      .frame(maxWidth: .infinity)
  }
  
  private func internalButton(_ title: String, intervalModifier: IntervalModifier) -> some View {
    Button(action: {
      vibrate()
      keyboardViewModel.intervalModifier = intervalModifier
    }) {
      internalButtonText(title)
    }
    .buttonStyle(EmbossedButtonStyle())
  }
  
  private func numberButton(_ inputNumber: Int) -> some View {
    Button(action: {
      vibrate()
      keyboardViewModel.setIntervalNumber(inputNumber)
    }) {
      let buttonText = inputNumber == 0 ? "0 / CLR" : "\(inputNumber)"
      internalButtonText(buttonText, color: .red)
    }
    .buttonStyle(EmbossedButtonStyle(pressedBorderColor: .blue))
  }
  
  private func enterButton(action: @escaping (() -> Void)) -> some View {
    Button(action: action) {
      Image(systemName: keyboardViewModel.answerMode.systemImageString)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(EmbossedButtonStyle(pressedBorderColor: .orange, backgroundColor: .orange.opacity(0.7)))
  }
  
  var body: some View {
    HStack(spacing: 16) {
      VStack {
        HStack {
          internalButton("완전음정", intervalModifier: .perfect)
        }
        
        HStack {
          internalButton("단음정", intervalModifier: .minor)
          internalButton("장음정", intervalModifier: .major)
        }
        
        HStack {
          internalButton("감음정", intervalModifier: .diminished)
          internalButton("증음정", intervalModifier: .augmented)
        }
        
        HStack {
          internalButton("겹감음정", intervalModifier: .doublyDiminished)
          internalButton("겹증음정", intervalModifier: .doublyAugmented)
        }
      }
      VStack {
        HStack {
          numberButton(7)
          numberButton(8)
          numberButton(9)
        }
        HStack {
          numberButton(4)
          numberButton(5)
          numberButton(6)
          
        }
        HStack {
          numberButton(1)
          numberButton(2)
          numberButton(3)
        }
        HStack {
          numberButton(0)
          enterButton {
            enterAction?()
          }
        }
      }
    }
  }
}

#Preview {
  IntervalTouchKeyboardView()
    .environmentObject(IntervalTouchKeyboardViewModel())
}
