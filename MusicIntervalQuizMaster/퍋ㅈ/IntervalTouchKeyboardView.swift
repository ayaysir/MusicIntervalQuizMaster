//
//  IntervalTouchKeyboardView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import SwiftUI

struct IntervalTouchKeyboardView: View {
  @EnvironmentObject var keyboardViewModel: IntervalTouchKeyboardViewModel
  
  private func internalButtonText(_ title: String) -> some View {
    Text(title)
      .foregroundStyle(.white)
      .padding()
      .frame(height: 50)
      .frame(maxWidth: .infinity)
      .background(Color.blue)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
  
  private func internalButton(_ title: String, action: @escaping (() -> Void)) -> some View {
    Button(action: action) {
      internalButtonText(title)
    }
  }
  
  var body: some View {
    HStack {
      VStack {
        HStack {
          internalButton("완전음정") {
            keyboardViewModel.appendText("P")
          }
        }
        
        HStack {
          internalButton("단음정") {
            keyboardViewModel.appendText("m")
          }
          internalButton("장음정") {
            keyboardViewModel.appendText("M")
          }
        }
        
        HStack {
          internalButton("감음정") {
            keyboardViewModel.appendText("d")
          }
          internalButton("증음정") {
            keyboardViewModel.appendText("a")
          }
        }
        
        HStack {
          internalButton("겹감음정") {
            keyboardViewModel.appendText("dd")
          }
          internalButton("겹증음정") {
            keyboardViewModel.appendText("aa")
          }
        }
      }
      VStack {
        HStack {
          internalButton("7") {
            keyboardViewModel.appendText("7")
          }
          internalButton("8") {
            keyboardViewModel.appendText("8")
          }
          internalButton("9") {
            keyboardViewModel.appendText("9")
          }
        }
        HStack {
          internalButton("4") {
            keyboardViewModel.appendText("4")
          }
          internalButton("5") {
            keyboardViewModel.appendText("5")
          }
          internalButton("6") {
            keyboardViewModel.appendText("6")
          }
        }
        HStack {
          internalButton("1") {
            keyboardViewModel.appendText("1")
          }
          internalButton("2") {
            keyboardViewModel.appendText("2")
          }
          internalButton("3") {
            keyboardViewModel.appendText("3")
          }
        }
        HStack {
          internalButton("0") {
            keyboardViewModel.appendText("0")
          }
          internalButton("<") {
            keyboardViewModel.backspace()
          }
          internalButton("+") {
            
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
