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
  
  var interval: Interval? {
    Interval.betweenNotes(startNote, endNote)
  }
  
  var description: String {
    """
    startNote: \(startNote.description)
    endNote: \(endNote.description)
    interval: \(interval?.description ?? "error")
    """
  }
}
