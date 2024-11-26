//
//  IntervalHelper.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/26/24.
//

import Foundation
import Tonic

struct IntervalHelper {
  static var shared = IntervalHelper()
}

struct AdvancedInterval: Equatable, Hashable {
  let modifier: IntervalModifier
  let number: Int
}

extension AdvancedInterval: CustomStringConvertible {
  var description: String {
    "\(modifier.abbrDescription)\(number)"
  }
}

extension AdvancedInterval {
  
  static func betweenNotes(_ note1: Note, _ note2: Note) -> AdvancedInterval? {
    let sortedNotes = [note1, note2].sorted(by: Note.sortNotes(_:_:))
    let (n1, n2) = (sortedNotes[0], sortedNotes[1])
    
    // 숫자 구하기
    let number = n2.relativeNotePosition - n1.relativeNotePosition + 1
    
    // 성질 구하기
    // 1. P 그룹인지 majMin그룹인지 정하기
    let essentialNumber = (number - 1) % 7 + 1
    let isPerfectGroup = [2, 3, 6, 7].contains(essentialNumber)
    let baseModifier: IntervalModifier = isPerfectGroup ? .major : .perfect
    
    // 2. 기본 반음수만큼 조정된 modifier 얻어내기
    // 예) C - F는 반음 1개이며 P4 >> 기본 modifier에서 조정할 필요가 없음 >> ()
    // 예) F - B는 반음 0개이며 A4 >> 기본 modifier에서 +1 (Perfect -> Augmented)
    // 예) C - B는 반음 1개이며 M7, D - C는 반음 2개이며 m7 >> -1 (Major -> minor)
    // 기본 반음수보다 반음 개수가 많으면 -1, 기본 반음수보다 개수가 적으면 +1
    // 기본 반음수 1 ~ 3도: 0 // 4 ~ 7도: 1 // 8 ~ 10: 2 // 11 ~ 14: 3
    let octaveDiff = (number - 1) / 7
    let defaultHalfsteps = (1...3 ~= essentialNumber ? 0 : 1) + (octaveDiff * 2)
    let adjustedHalfsteps = halfsteps(n1, n2) - defaultHalfsteps
    let semitone = -(n1.accidental.adjustValue) + n2.accidental.adjustValue
    // print("hs, dhs, adj:", halfsteps(n1, n2), defaultHalfsteps, adjustedHalfsteps)
    
    if let adjustedModifier = baseModifier.move(isPerfectGroup: isPerfectGroup, count: -adjustedHalfsteps + semitone) {
      return .init(modifier: adjustedModifier, number: number)
    }
    
    return nil
  }
  
  static func halfsteps(_ note1: Note, _ note2: Note) -> Int {
    let sortedNotes = [note1, note2].sorted(by: Note.sortNotes(_:_:))
    let (n1, n2) = (sortedNotes[0], sortedNotes[1])
    
    guard n1.relativeNotePosition < n2.relativeNotePosition else {
      return 0
    }
    
    return ((n1.relativeNotePosition + 2)...(n2.relativeNotePosition + 1)).reduce(0) {
      $0 + (($1 % 7 == 4 || $1 % 7 == 1) ? 1 : 0)
    }
  }
}
