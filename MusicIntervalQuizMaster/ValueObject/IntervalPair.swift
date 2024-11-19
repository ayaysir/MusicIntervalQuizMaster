//
//  IntervalPair.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/16/24.
//

import Tonic

struct IntervalPair: CustomStringConvertible {
  let startNote: Note
  let endNote: Note
  let category: IntervalPairCategory
  let clef: Clef
  
  var interval: Interval? {
    Interval.betweenNotes(startNote, endNote)
  }
  
  var description: String {
    """
    category: \(category)
    startNote: \(startNote.description) (\(startNote.noteNumber))
    endNote: \(endNote.description) (\(endNote.noteNumber))
    interval: \(interval?.description ?? "error")
    """
  }
}

