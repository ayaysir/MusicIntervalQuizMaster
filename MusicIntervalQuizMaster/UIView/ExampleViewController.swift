//
//  ExampleViewController.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 10/9/24.
//

import UIKit
import SwiftUI

protocol CustomKeyboardDelegate: AnyObject {
  func keyWasTapped(character: String)
}

class ExampleViewController: UIViewController, CustomKeyboardDelegate {
  // UITextField를 코드로 생성
  let textField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  // CustomKeyboardView 생성
  let customKeyboard = CustomKeyboardView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // textField를 뷰에 추가
    view.addSubview(textField)
    // view.addSubview(customKeyboard)
    
    // 이거 넣어줘야 키보드가 표시됨 (CustomKeyboardView에 넣었음)
    // customKeyboard.translatesAutoresizingMaskIntoConstraints = false
    
    // Auto Layout 설정
    NSLayoutConstraint.activate([
      textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      textField.widthAnchor.constraint(equalToConstant: 250),
      textField.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    // 커스텀 키보드 델리게이트 설정
    customKeyboard.delegate = self
    
    // NSLayoutConstraint.activate([
    //   customKeyboard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //   customKeyboard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    //   customKeyboard.widthAnchor.constraint(equalToConstant: 250),
    //   customKeyboard.heightAnchor.constraint(equalToConstant: 40)
    // ])
    
    // 커스텀 키보드를 inputView로 설정
    textField.inputView = customKeyboard
    textField.becomeFirstResponder()
  }
  
  // CustomKeyboardDelegate 프로토콜 구현
  func keyWasTapped(character: String) {
    textField.insertText(character)
  }
}

struct ExampleViewControllerRepresentable: UIViewControllerRepresentable {
  
  func makeUIViewController(context: Context) -> ExampleViewController {
    let viewController = ExampleViewController()
    
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: ExampleViewController, context: Context) {
    // 필요 시 업데이트
  }
}

@available(iOS 17.0, *)
#Preview {
  ExampleViewControllerRepresentable()
}
