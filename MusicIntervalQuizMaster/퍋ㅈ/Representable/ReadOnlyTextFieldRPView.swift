//
//  ReadOnlyTextFieldRPView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import SwiftUI

struct ReadOnlyTextFieldRPView: UIViewRepresentable {
  @Binding var text: String
  
  func makeUIView(context: Context) -> UITextField {
    let textField = UITextField()
    textField.delegate = context.coordinator // 커서와 키보드 비활성화를 위해 delegate 사용
    textField.borderStyle = .none            // 기본 테두리 제거
    textField.isUserInteractionEnabled = true // 상호작용 가능
    return textField
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.text = text // 외부에서 전달된 값으로 업데이트
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator()
  }
  
  // Coordinator: 키보드와 커서를 비활성화
  class Coordinator: NSObject, UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      // 커서 표시 및 키보드 비활성화
      return false
    }
  }
}
