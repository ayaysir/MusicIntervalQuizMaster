//
//  Tonic.Note+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import Tonic

extension Note {
  func musiqwikText(clef: Clef,
                    leftAccidental: Accidental,
                    rightAccidental: Accidental,
                    isForSimultaneousNotes: Bool = false,
                    isRightNote: Bool = false,
                    isSameNotePosition: Bool = false,
                    isNeedSeparateNotes: Bool = false,
                    isNeedSeparateAccidentals: Bool = false
  ) -> String {
    let startScalar = clef.musiqwikBaseScalar + (octave * 7)
    let unicodeNumber = startScalar + letter.rawValue
    let noteText = "\(String(UnicodeScalar(unicodeNumber)!))"
    
    // sharp: 112 -> 208 => 112(pitch) + 96(constant)
    // flat: 112 -> 224 => 112(pitch) + 112(constant)
    // natural: 112 -> 240 => 112(pitch) + 128(constant)
    
    let S = String(UnicodeScalar(96 + unicodeNumber)!)
    let F = String(UnicodeScalar(112 + unicodeNumber)!)
    let N = String(UnicodeScalar(128 + unicodeNumber)!)
    
    // left note인 경우 natural 이 존재할 수 없음
    let accidentalText = switch accidental {
    case .flat:
      F
    case .sharp:
      S
    case .natural:
      // if need show natural sign
      if leftAccidental != .natural && rightAccidental == .natural && isSameNotePosition {
        N
      } else {
        ""
      }
    case .doubleFlat:
      "\(F)\(F)"
    case .doubleSharp:
      "\(S)\(S)"
    }
    
    var spaceRelateOnRightAccidental: String {
      switch rightAccidental {
      case .doubleSharp, .doubleFlat:
        "=="
      case .sharp, .flat:
        "="
      case .natural:
        ""
      }
    }
    
    let baseText = if isNeedSeparateNotes && isNeedSeparateAccidentals {
      isRightNote ? "\(spaceRelateOnRightAccidental)\(accidentalText)=\(noteText)" : "\(accidentalText)\(spaceRelateOnRightAccidental)\(noteText)="
    } else if isNeedSeparateNotes {
      isRightNote ? "\(accidentalText)=\(noteText)" : "\(accidentalText)\(noteText)="
    } else if isNeedSeparateAccidentals {
      isRightNote ? "\(spaceRelateOnRightAccidental)\(accidentalText)\(noteText)" : "\(accidentalText)\(spaceRelateOnRightAccidental)\(noteText)"
    } else {
      "\(accidentalText)\(noteText)"
    }
    
    let maxCount = if isNeedSeparateNotes && isNeedSeparateAccidentals {
      rightAccidental == .doubleFlat || rightAccidental == .doubleSharp ? 6 : 5
    } else if isNeedSeparateNotes {
      4
    } else if isNeedSeparateAccidentals {
      rightAccidental == .doubleFlat || rightAccidental == .doubleSharp ? 5 : 4
    } else {
      3
    }
    
    // 2도인 경우 임시표, 음표 겹침, 3도인 경우 임시표만 겹침
    // 2도이면서 임시표가 둘 다 없거나 한 개 노트에만 있는 경우 음표만 분리
    // 2도이면서 임시표가 둘 다 있다면 음표 및 임시표 분리
    // 3도라면 임시표만 분리
    if isForSimultaneousNotes {
      let paddingCount = max(0, maxCount - baseText.count)
      let padding = String(repeating: "=", count: paddingCount)
      
      return padding + baseText
    }
    
    return baseText
  }
  
  var orthodoxPitch: Int {
    12 + letter.basePitch + Int(accidental.rawValue) + octave * 12
  }
  
  var relativeNotePosition: Int {
    letter.rawValue + octave * 7
  }
  
  func playSound() {
    SoundManager.shared.playSound(midiNumber: orthodoxPitch)
  }
  
  static func sortNotes(_ lhs: Note, _ rhs: Note) -> Bool {
    if lhs.relativeNotePosition != rhs.relativeNotePosition {
      lhs.relativeNotePosition < rhs.relativeNotePosition
    } else {
      lhs.accidental.rawValue < rhs.accidental.rawValue
    }
  }
}

extension Note {
  static func from(letterString: String, accidentalString: String, octave: Int) -> Note? {
    // Convert letterString to Letter
    guard let letter = Letter.allCases.first(where: { "\($0)" == letterString.uppercased() }) else {
      print("Invalid letter string: \(letterString)")
      return nil
    }

    // Convert accidentalString to Accidental
    let accidentalMap: [String: Accidental] = [
      "𝄫": .doubleFlat,
      "♭": .flat,
      "": .natural,
      "♯": .sharp,
      "𝄪": .doubleSharp
    ]
    
    guard let accidental = accidentalMap[accidentalString] else {
      print("Invalid accidental string: \(accidentalString)")
      return nil
    }

    // Ensure octave is in a reasonable range
    guard (0...10).contains(octave) else {
      print("Invalid octave value: \(octave)")
      return nil
    }

    // Create and return the Note object
    return Note(letter, accidental: accidental, octave: octave)
  }
}
