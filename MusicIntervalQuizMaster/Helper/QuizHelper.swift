//
//  QuizHelper.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 1/31/25.
//

import Tonic

struct QuizHelper {
  static let shared = QuizHelper()
  private init() {}
  
  func generateRandomIntervalPair() -> IntervalPair? {
    guard let category = determinedCategory,
          let clef = determinedClef,
          let accidental1 = determinedAccidental,
          let accidental2 = determinedAccidental
    else {
      print("category, clef, accidental는 반드시 만들어져야 하는데:",
            determinedCategory as Any,
            determinedClef as Any,
            determinedAccidental as Any,
            store.bool(forKey: .checkInitConfigCompleted)
      )
      
      print(store.bool(forKey: .cfgNotesAscending),
            store.bool(forKey: .cfgNotesDescending),
            store.bool(forKey: .cfgNotesSimultaneously)
      )
      return nil
    }
    
    let startLetter = Letter(rawValue: .random(in: 0...6))
    let endLetter = Letter(rawValue: .random(in: 0...6))
    
    guard let startLetter, let endLetter else {
      return nil
    }
    
    let startOctave = clef.randomAvailableOctave(startLetter)
    let endOctave = clef.randomAvailableOctave(endLetter)
    
    let notes: [Note] = [
      .init(startLetter, accidental: accidental1, octave: startOctave),
      .init(endLetter, accidental: accidental2, octave: endOctave),
    ].sorted {
      if $0.relativeNotePosition != $1.relativeNotePosition {
        $0.relativeNotePosition < $1.relativeNotePosition
      } else {
        $0.accidental.rawValue < $1.accidental.rawValue
      }
    }
    
    let pair = IntervalPair(
      startNote: category != .descending ? notes[0] : notes[1],
      endNote: category != .descending ? notes[1] : notes[0],
      direction: category,
      clef: clef
    )
    
    return pair
  }
  
  func availableIntervalList() -> [AdvancedInterval] {
    var list: [AdvancedInterval] = []
    
    do {
      let boolStates = try store.getObject(forKey: .cfgIntervalTypeStates, castTo: StringBoolDict.self)
      
      boolStates.forEach {
        let splitted = $0.key.split(separator: "_")
        
        guard let number = Int(splitted[1]),
              let modifier = IntervalModifier.from(abbreviation: String(splitted[0])) else {
          return
        }
        
        let isIncludeCompound = store.bool(forKey: .cfgIntervalFilterCompound)
        let isIncludeDoublyTritone = store.bool(forKey: .cfgIntervalFilterDoublyTritone)
        
        /*
         꺼져 있을 때
         [P1, m2, M2, d2, m3, M3, d3, P4, A4, d4, m5, M5, A5, d5, P6, A6, d6, m7, M7, d7, P8, A8, d8]

         둘 다 켜져 있을 때
         [P1, m2, M2, d2, m3, M3, d3, P4, A4, AA4, d4, dd4, m5, M5, A5, AA5, d5, dd5, P6, A6, d6, m7, M7, d7, P8, A8, d8, m12, M12, P13]

         차이점
         [AA4, AA5, dd4, dd5, m12, M12, P13]
         */
        guard $0.value,
              (isIncludeCompound || number <= 8), // isIncludeCompound가 false면 number <= 8 이어야 함
              (isIncludeDoublyTritone || (modifier != .doublyAugmented && modifier != .doublyDiminished)) // isIncludeDoublyTritone가 false면 특정 modifier 포함 금지
        else {
          return
        }
        
        list.append(.init(modifier: modifier, number: number))
      }
    } catch {
      print(error)
    }
    
    if list.isEmpty {
      return [AdvancedInterval(modifier: .perfect, number: 5)]
    }
    
    return list
  }
}

extension QuizHelper {
  var determinedCategory: IntervalPairDirection? {
    [
      store.bool(forKey: .cfgNotesAscending) ? IntervalPairDirection.ascending : nil,
      store.bool(forKey: .cfgNotesDescending) ? IntervalPairDirection.descending : nil,
      store.bool(forKey: .cfgNotesSimultaneously) ? IntervalPairDirection.simultaneously : nil,
    ].compactMap { $0 }.randomElement()
  }
  
  var determinedClef: Clef? {
    [
      store.bool(forKey: .cfgClefTreble) ? Clef.treble : nil,
      store.bool(forKey: .cfgClefBass) ? Clef.bass : nil,
      store.bool(forKey: .cfgClefAlto) ? Clef.alto : nil,
    ].compactMap { $0 }.randomElement()
  }
  
  var determinedAccidental: Accidental? {
    [
      Accidental.natural, Accidental.natural, Accidental.natural,
      store.bool(forKey: .cfgAccidentalSharp) ? Accidental.sharp : nil,
      store.bool(forKey: .cfgAccidentalFlat) ? Accidental.flat : nil,
      store.bool(forKey: .cfgAccidentalDoubleSharp) ? Accidental.doubleSharp : nil,
      store.bool(forKey: .cfgAccidentalDoubleFlat) ? Accidental.doubleFlat : nil,
    ].compactMap { $0 }.randomElement()
  }
}
