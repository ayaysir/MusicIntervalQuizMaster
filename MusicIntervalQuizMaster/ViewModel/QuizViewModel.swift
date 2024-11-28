//
//  ContentViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/15/24.
//

import Foundation
import Tonic

final class QuizViewModel: ObservableObject {
  private(set) var pairs: [IntervalPair] = []
  @Published private(set) var currentPairCount = 0
  @Published private(set) var lastMaxPairCount = 0
  @Published var currentSessionDict: [Int : Bool] = [:]
  
  init() {
    if !store.bool(forKey: .checkInitConfigCompleted) {
      MusicIntervalQuizMasterApp.initConfigValues()
    }
    
    preparePairData()
  }
  
  func preparePairData() {
    pairs = []
    currentPairCount = 0
    currentSessionDict = [:]
    
    let availableIntervalList = if !availableIntervalList.isEmpty {
      availableIntervalList
    } else {
      [
        AdvancedInterval(modifier: .perfect, number: 5)
      ]
    }
    
    print(availableIntervalList)
    
    while pairs.count <= 1000 {
      if let pair = generateRandomIntervalPair(),
         let interval = pair.advancedInterval,
         availableIntervalList.contains(interval) {
        pairs.append(pair)
      }
    }
  }
  
  var answerCount: Int {
    currentSessionDict.filter { $0.value }.count
  }
  
  var wrongCount: Int {
    currentSessionDict.count - answerCount
  }
  
  var currentPairIsNotSolved: Bool {
    currentSessionDict[currentPairCount] == nil
  }
  
  func appendAnswerCount(isCorrect: Bool) {
    if isCorrect {
      if currentPairIsNotSolved {
        currentSessionDict[currentPairCount] = true
      }
    } else {
      currentSessionDict[currentPairCount] = false
    }
  }
  
  var isNextQuestionAlreadyAppeared: Bool {
    currentPairCount + 1 <= lastMaxPairCount
  }
  
  var currentPair: IntervalPair {
    pairs[currentPairCount]
  }
  
  func next() {
    guard currentPairCount <= pairs.count - 1 else {
      return
    }
    
    currentPairCount += 1
    
    lastMaxPairCount = max(lastMaxPairCount, currentPairCount)
  }
  
  func prev() {
    guard currentPairCount > 0 else {
      return
    }
    
    currentPairCount -= 1
  }
  
  private func generateRandomIntervalPair() -> IntervalPair? {
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
      category: category,
      clef: clef
    )
    
    return pair
  }
  
  var determinedCategory: IntervalPairCategory? {
    [
      store.bool(forKey: .cfgNotesAscending) ? IntervalPairCategory.ascending : nil,
      store.bool(forKey: .cfgNotesDescending) ? IntervalPairCategory.descending : nil,
      store.bool(forKey: .cfgNotesSimultaneously) ? IntervalPairCategory.simultaneously : nil,
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
  
  var availableIntervalList: [AdvancedInterval] {
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
    
    return list
  }
}
