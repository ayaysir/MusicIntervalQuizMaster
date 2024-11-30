//
//  ColorScheme+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/30/24.
//

import SwiftUI

extension ColorScheme {
  static func fromAppAppearance(_ appearance: Int) -> ColorScheme? {
    switch appearance {
    case 1: return .light
    case 2: return .dark
    default: return nil // 시스템 설정 따름
    }
  }
}
