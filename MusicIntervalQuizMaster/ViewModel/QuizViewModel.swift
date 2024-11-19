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
  
  var currentPair: IntervalPair {
    pairs[currentPairCount]
  }
  
  init() {
    for _ in 0..<100000 {
      pairs.append(generateRandomIntervalPair()!)
    }
  }
  
  func next() {
    guard currentPairCount <= pairs.count - 1 else {
      return
    }
    
    currentPairCount += 1
  }
  
  func prev() {
    guard currentPairCount > 0 else {
      return
    }
    
    currentPairCount -= 1
  }
  
  private func generateRandomIntervalPair() -> IntervalPair? {
    guard let category = determinedCategory,
          let clef = determinedClef else {
      print("category, clef는 반드시 만들어져야 하는데")
      return nil
    }
    
    // TODO: - 더블 샵, 더블 플랫이 포함되거나, 복합음정이라도 음정이 표시되도록 Interval 업그레이드 (현재 기능이 부실함)
    
    let startLetter = Letter(rawValue: .random(in: 0...6))
    let startAccidental = Accidental(rawValue: .random(in: -1...1))
    
    let endLetter = Letter(rawValue: .random(in: 0...6))
    let endAccidental = Accidental(rawValue: .random(in: -1...1))
    
    guard let startLetter, let startAccidental, let endLetter, let endAccidental else {
      return nil
    }
    
    let startOctave = clef.randomAvailableOctave(startLetter)
    let endOctave = clef.randomAvailableOctave(endLetter)
    
    let notes: [Note] = [
      .init(startLetter, accidental: startAccidental, octave: startOctave),
      .init(endLetter, accidental: endAccidental, octave: endOctave),
    ].sorted(by: sortNotes)
    
    let pair = IntervalPair(
      startNote: category != .descending ? notes[0] : notes[1],
      endNote: category != .descending ? notes[1] : notes[0],
      category: category,
      clef: clef
    )
    
    return pair
  }
  
  func sortNotes(_ lhs: Note, _ rhs: Note) -> Bool {
    let ascResult = if lhs.octave != rhs.octave {
      lhs.octave < rhs.octave
    } else if lhs.letter.rawValue != rhs.letter.rawValue {
      lhs.letter.rawValue < rhs.letter.rawValue
    } else {
      lhs.accidental.rawValue < rhs.accidental.rawValue
    }
    
    return ascResult
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
}
