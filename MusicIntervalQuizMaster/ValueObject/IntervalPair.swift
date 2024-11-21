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
    startNote: \(startNote.description) (\(startNote.noteNumber)) (\(startNote.orthodoxPitch))
    [octave: \(startNote.octave), letterBasePitch: \(startNote.letter.basePitch), accRawValue: \(startNote.accidental.rawValue)]
    endNote: \(endNote.description) (\(endNote.noteNumber)) (\(endNote.orthodoxPitch))
    [octave: \(endNote.octave), letterBasePitch: \(endNote.letter.basePitch), accRawValue: \(endNote.accidental.rawValue)]
    interval: \(interval?.description ?? "error")
    """
  }
}

