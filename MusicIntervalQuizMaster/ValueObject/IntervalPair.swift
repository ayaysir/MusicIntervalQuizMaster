//
//  IntervalPair.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import Tonic

struct IntervalPair: CustomStringConvertible, Equatable, Hashable {
  let startNote: Note
  let endNote: Note
  let category: IntervalPairCategory
  let clef: Clef
  
  var interval: Interval? {
    Interval.betweenNotes(startNote, endNote)
  }
  
  var advancedInterval: AdvancedInterval? {
    AdvancedInterval.betweenNotes(startNote, endNote)
  }
  
  var description: String {
    """
    category: \(category)
    startNote: \(startNote.description) (\(startNote.noteNumber)) (\(startNote.orthodoxPitch))
    endNote: \(endNote.description) (\(endNote.noteNumber)) (\(endNote.orthodoxPitch))
    interval: \(interval?.description ?? "error")
    AdvancedInterval: \(advancedInterval?.description ?? "error")
    """
  }
}

