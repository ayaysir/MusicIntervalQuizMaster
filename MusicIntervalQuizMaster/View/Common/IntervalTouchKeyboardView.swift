//
//  IntervalTouchKeyboardView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import SwiftUI

struct IntervalTouchKeyboardView: View {
  @ObservedObject var keyboardViewModel: IntervalTouchKeyboardViewModel
  @AppStorage(.cfgHapticPressedIntervalKeyboard) var isHaptic = false
  
  let enterAction: (() -> Void)?
  
  init(keyboardViewModel: IntervalTouchKeyboardViewModel, enterAction: (() -> Void)? = nil) {
    self._keyboardViewModel = .init(wrappedValue: keyboardViewModel)
    self.enterAction = enterAction
  }
  
  private func vibrate() {
    if isHaptic {
      HapticManager.rigid.vibrate()
    }
  }
  
  private func internalButtonText(_ title: String, color: Color = .intervalButtonBackground) -> some View {
    Text(title)
      .fontWeight(.medium)
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
    .buttonStyle(EmbossedButtonStyle(pressedBorderColor: .purple))
  }
  
  private func numberButton(_ inputNumber: Int) -> some View {
    Button(action: {
      vibrate()
      keyboardViewModel.setIntervalNumber(inputNumber)
    }) {
      let buttonText = inputNumber == 0 ? "0 / CLR" : "\(inputNumber)"
      internalButtonText(buttonText, color: .red)
    }
    .buttonStyle(EmbossedButtonStyle(pressedBorderColor: .cyan))
  }
  
  private func enterButton(action: @escaping (() -> Void)) -> some View {
    Button(action: action) {
      Image(systemName: keyboardViewModel.answerMode.systemImageString)
        .fontWeight(.medium)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(EmbossedButtonStyle(pressedBorderColor: .orange, backgroundColor: .orange.opacity(0.7)))
  }
  
  var body: some View {
    HStack(spacing: 16) {
      VStack {
        HStack {
          internalButton(IntervalModifier.perfect.keyboardLocalizedDescription, intervalModifier: .perfect)
        }
        
        HStack {
          internalButton(IntervalModifier.minor.keyboardLocalizedDescription, intervalModifier: .minor)
          internalButton(IntervalModifier.major.keyboardLocalizedDescription, intervalModifier: .major)
        }
        
        HStack {
          internalButton(IntervalModifier.diminished.keyboardLocalizedDescription, intervalModifier: .diminished)
          internalButton(IntervalModifier.augmented.keyboardLocalizedDescription, intervalModifier: .augmented)
        }
        
        HStack {
          internalButton(IntervalModifier.doublyDiminished.keyboardLocalizedDescription, intervalModifier: .doublyDiminished)
          internalButton(IntervalModifier.doublyAugmented.keyboardLocalizedDescription, intervalModifier: .doublyAugmented)
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
  IntervalTouchKeyboardView(keyboardViewModel: .init())
    .environmentObject(IntervalTouchKeyboardViewModel())
}
