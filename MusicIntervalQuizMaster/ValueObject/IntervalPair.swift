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
  let direction: IntervalPairDirection
  let clef: Clef
  
  var advancedInterval: AdvancedInterval? {
    AdvancedInterval.betweenNotes(startNote, endNote)
  }
  
  var description: String {
    """
    category: \(direction)
    startNote: \(startNote.description) (\(startNote.noteNumber)) (\(startNote.orthodoxPitch))
    endNote: \(endNote.description) (\(endNote.noteNumber)) (\(endNote.orthodoxPitch))
    AdvancedInterval: \(advancedInterval?.description ?? "error")
    """
  }
}

