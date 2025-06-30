//
//  Signature.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Foundation
import Tonic

enum Clef: HasMusiqwikText, CaseIterable {
  case treble, bass, alto
  
  // dataDescription 값을 기반으로 enum으로 초기화
  init?(dataDescription: String?) {
    switch dataDescription {
    case "treble":
      self = .treble
    case "bass":
      self = .bass
    case "alto":
      self = .alto
    default:
      return nil // 유효하지 않은 값
    }
  }
  
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
  
  var musiqwikTextWithSpace: String {
    "=\(self.musiqwikText)="
  }
  
  var localizedDescription: String {
    switch self {
    case .treble:
      "clef_treble".localized
    case .bass:
      "clef_bass".localized
    case .alto:
      "clef_alto".localized
    }
  }
  
  var shortLocalizedDescription: String {
    switch self {
    case .treble:
      "clef_treble_short".localized
    case .bass:
      "clef_bass_short".localized
    case .alto:
      "clef_alto_short".localized
    }
  }
  
  var dataDescription: String {
    switch self {
    case .treble:
      "treble"
    case .bass:
      "bass"
    case .alto:
      "alto"
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
  
  func randomAvailableOctave(_ letter: Letter) -> Int {
    switch self {
    case .treble:
      // A3 ~ A5: A3 B3 C4 ...A4 B4 C5 ... A5
      if letter == .A {
        Int.random(in: 3...5)
      } else if letter == .B {
        Int.random(in: 3...4)
      } else {
        Int.random(in: 4...5)
      }
    case .bass:
      // C2 ~ C4: C2 D2 E2 ...A2 B2 C3 D3 E3... A3 B3 C4
      if letter == .C {
        Int.random(in: 2...4)
      } else {
        Int.random(in: 2...3)
      }
    case .alto:
      // B2 ~ B4: B2 C3 D3 ... A3 B3 C4 D4 ... A4 B4
      if letter == .B {
        Int.random(in: 2...4)
      } else {
        Int.random(in: 3...4)
      }
    }
  }
}
