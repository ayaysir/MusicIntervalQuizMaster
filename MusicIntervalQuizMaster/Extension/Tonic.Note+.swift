//
//  Tonic.Note+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Tonic

extension Note {
  // TODO: - 1. 동시 표시에서 임시표가 겹치는 경우 위치 조절
  // TODO: - 2. 동시 표시에서 음이 같은 경우 음표 및 임시표 위치 표시 방법
  func musiqwikText(clef: Clef, isNaturalNeeded: Bool = false) -> String {
    let startScalar = clef.musiqwikBaseScalar + (octave * 7)
    let unicodeNumber = startScalar + letter.rawValue
    let noteText = "\(String(UnicodeScalar(unicodeNumber)!))"
    
    // sharp: 112 -> 208 => 112(pitch) + 96(constant)
    // flat: 112 -> 224 => 112(pitch) + 112(constant)
    // natural: 112 -> 242 => 112(pitch) + 130(constant)
    
    let S = String(UnicodeScalar(96 + unicodeNumber)!)
    let F = String(UnicodeScalar(112 + unicodeNumber)!)
    let N = String(UnicodeScalar(130 + unicodeNumber)!)
    
    let accidentalText = switch accidental {
    case .flat:
      "=\(F)"
    case .sharp:
      "=\(S)"
    case .natural:
      // if need show natural sign
      isNaturalNeeded ? "=\(N)" : "=="
    case .doubleFlat:
      "\(F)\(F)"
    case .doubleSharp:
      "\(S)\(S)"
    }
    
    return "\(accidentalText)\(noteText)"
  }
  
  
}
