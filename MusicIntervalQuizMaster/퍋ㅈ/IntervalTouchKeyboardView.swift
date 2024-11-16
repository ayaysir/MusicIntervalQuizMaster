//
//  IntervalTouchKeyboardView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import SwiftUI

struct EmbossedButtonStyle: ButtonStyle {
  var pressedBorderColor: Color = .red
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.vertical, 5)
      // .padding(.horizontal, 0)
      .background(
        ZStack {
          // 아래 그림자 (눌렀을 때 변화 강조)
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .shadow(
              color: configuration.isPressed ? .gray.opacity(0.3) : .gray.opacity(0.5),
              radius: configuration.isPressed ? 2 : 5,
              x: configuration.isPressed ? 1 : 3,
              y: configuration.isPressed ? 1 : 3
            )
          
          // 위 그림자 (눌렀을 때 변화 강조)
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .shadow(
              color: configuration.isPressed ? .white.opacity(0.5) : .white.opacity(0.8),
              radius: configuration.isPressed ? 1 : 5,
              x: configuration.isPressed ? -1 : -3,
              y: configuration.isPressed ? -1 : -3
            )
          
          // 버튼 배경
          RoundedRectangle(cornerRadius: 10)
            .fill(LinearGradient(
              gradient: Gradient(colors: [
                configuration.isPressed ? .intervalButtonBackground.opacity(0.9) : .intervalButtonBackground.opacity(0.7),
                configuration.isPressed ? .intervalButtonBackground.opacity(0.6) : .intervalButtonBackground
              ]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ))
        }
      )
      .overlay(
        // 테두리
        RoundedRectangle(cornerRadius: 10)
          .stroke(configuration.isPressed ? pressedBorderColor : .intervalButtonBorder, lineWidth: configuration.isPressed ? 2 : 1)
      )
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // 클릭 시 축소 효과 강조
      // .animation(.spring(response: 0, dampingFraction: 0.5), value: configuration.isPressed)
    
  }
}

struct IntervalTouchKeyboardView: View {
  @EnvironmentObject var keyboardViewModel: IntervalTouchKeyboardViewModel
  
  private func internalButtonText(_ title: String, color: Color = .intervalButtonBackground) -> some View {
    Text(title)
      .frame(height: 50)
      .frame(maxWidth: .infinity)
  }
  
  private func internalButton(_ title: String, intervalModifier: IntervalModifier) -> some View {
    Button(action: {
      keyboardViewModel.intervalModifier = intervalModifier
    }) {
      internalButtonText(title)
    }
    .buttonStyle(EmbossedButtonStyle())
  }
  
  private func numberButton(_ inputNumber: Int) -> some View {
    Button(action: {
      keyboardViewModel.setIntervalNumber(inputNumber)
    }) {
      let buttonText = inputNumber == 0 ? "0 / CLR" : "\(inputNumber)"
      internalButtonText(buttonText, color: .red)
    }
    .buttonStyle(EmbossedButtonStyle(pressedBorderColor: .blue))
  }
  
  private func enterButton(action: @escaping (() -> Void)) -> some View {
    Button(action: action) {
      Image(systemName: "return")
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(EmbossedButtonStyle(pressedBorderColor: .orange))
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
