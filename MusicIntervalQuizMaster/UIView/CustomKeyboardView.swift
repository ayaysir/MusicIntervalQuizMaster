//
//  CustomKeyboardView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 10/9/24.
//

import UIKit

class CustomKeyboardView: UIView {
  var delegate: CustomKeyboardDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupKeys()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupKeys()
  }
  
  private func setupKeys() {
    let buttonTitles = ["P", "M", "m", "d", "A", "dd", "AA", "_"]
    
    let buttonStackView = UIStackView()
    buttonStackView.axis = .horizontal
    buttonStackView.distribution = .fillEqually
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let numberStackView = UIStackView()
    numberStackView.axis = .horizontal
    numberStackView.distribution = .fillEqually
    numberStackView.translatesAutoresizingMaskIntoConstraints = false
    
    for title in buttonTitles {
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      button.addTarget(self, action: #selector(keyTapped), for: .touchUpInside)
      buttonStackView.addArrangedSubview(button)
    }
    
    for number in 0...9 {
      let button = UIButton(type: .system)
      button.setTitle("\(number)", for: .normal)
      button.addTarget(self, action: #selector(keyTapped), for: .touchUpInside)
      numberStackView.addArrangedSubview(button)
    }
    
    addSubview(buttonStackView)
    addSubview(numberStackView)
    
    // 버튼의 높이를 설정합니다.
    let buttonHeight: CGFloat = 50

    // buttonStackView 제약 조건 설정
    NSLayoutConstraint.activate([
        buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        buttonStackView.topAnchor.constraint(equalTo: topAnchor),
        // buttonStackView.heightAnchor.constraint(equalToConstant: buttonHeight) // 버튼 높이에 맞추어 높이 설정
    ])

    // numberStackView 제약 조건 설정
    NSLayoutConstraint.activate([
        numberStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        numberStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        numberStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor), // buttonStackView 바로 아래에 배치
        // numberStackView.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor) // 높이를 buttonStackView와 동일하게 설정
    ])
    
    // buttonStackView, numberStackView의 heightAnchor는 intrinsicContentSize에 의해 자동 결정됨

    // 두 스택을 수직 중앙에 배치하기 위한 제약 조건 추가
    NSLayoutConstraint.activate([
        buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -buttonHeight / 2), // 중앙에서 위로 이동
        numberStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: buttonHeight / 2) // 중앙에서 아래로 이동
    ])
    
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  @objc private func keyTapped(_ sender: UIButton) {
    if let key = sender.title(for: .normal) {
      delegate?.keyWasTapped(character: key)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  CustomKeyboardView()
}
