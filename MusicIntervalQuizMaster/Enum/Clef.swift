//
//  Signature.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Foundation

enum Clef: HasMusiqwikText, CaseIterable {
  case treble, bass, alto
  
  var musiqwikText: String {
    switch self {
    case .treble:
      "&"
    case .bass:
      "¯"
    case .alto:
      "ÿ"
    }
  }
  
  var localizedDescription: String {
    switch self {
    case .treble:
      "Treble Clef (G Clef)"
    case .bass:
      "Bass Clef (F Clef)"
    case .alto:
      "Alto Clef (C Clef)"
    }
  }
  
  var musiqwikBaseScalar: Int {
    // 반드시 Unicode Scalar 112 ~ 126 사이에 위치
    // treble: 86 + (octave * 7)
    // bass: 98 + (octave * 7) >> 2 = 112, 3 = 119, 4 = 126
    // alto: 92 + (ocatve * 7)
    
    switch self {
    case .treble:
      86
    case .bass:
      98
    case .alto:
      92
    }
  }
}
