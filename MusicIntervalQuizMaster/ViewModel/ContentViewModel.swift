//
//  ContentViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/15/24.
//

import Foundation
import Tonic

final class ContentViewModel: ObservableObject {
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
    // TODO: - 더블 샵, 더블 플랫이 포함되거나, 복합음정이라도 음정이 표시되도록 Interval 업그레이드 (현재 기능이 부실함)
    let startLetter = Letter(rawValue: .random(in: 0...6))
    let startAccidental = Accidental(rawValue: .random(in: -1...1))
    let startOctave = Int.random(in: 3...5)
    
    let endLetter = Letter(rawValue: .random(in: 0...6))
    let endAccidental = Accidental(rawValue: .random(in: -1...1))
    let endOctave = Int.random(in: 3...5)
    
    guard let startLetter, let startAccidental, let endLetter, let endAccidental else {
      return nil
    }
    
    let pair = IntervalPair(
      startNote: .init(startLetter, accidental: startAccidental, octave: startOctave),
      endNote: .init(endLetter, accidental: endAccidental, octave: endOctave), 
      category: .ascending, 
      clef: .treble
    )
    
    return pair
  }
}
