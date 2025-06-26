//
//  ColorScheme+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/30/24.
//

import SwiftUI

extension ColorScheme {
  /// 1이면 light, 2이면 dark, 그 외의 경우 시스템 설정 반환
  static func fromAppAppearance(_ appearance: Int) -> ColorScheme? {
    switch appearance {
    case 1: return .light
    case 2: return .dark
    default: return nil // 시스템 설정 따름
    }
  }
}
