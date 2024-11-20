//
//  MusiqwikView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import SwiftUI

extension IntervalPair {
  var musiqwikSheetArea: some View {
    ZStack {
      let isNaturalNeeded = {
        let cond1 = startNote.octave == endNote.octave
        let cond2 = startNote.letter == endNote.letter
        let cond3 = startNote.accidental != .natural && endNote.accidental == .natural
        
        return cond1 && cond2 && cond3
      }()
      
      let startNoteText = startNote.musiqwikText(clef: clef)
      let endNoteText = endNote.musiqwikText(clef: clef, isNaturalNeeded: isNaturalNeeded)
      
      if category == .simultaneously {
        let left = "'\(clef.musiqwikText)====="
        let right = "=====\""
        
        Text("\(left)\(startNoteText)\(right)")
          .font(.custom("Musiqwik", size: 50))
        Text("\(left)\(endNoteText)\(right)")
          .font(.custom("Musiqwik", size: 50))
      } else {
        Text("'\(clef.musiqwikText)===\(startNoteText)===\(endNoteText)===\"")
          .font(.custom("Musiqwik", size: 50))
      }
    }
  }
}

struct MusiqwikView: View {
  let pair: IntervalPair
  
  var body: some View {
    pair.musiqwikSheetArea
  }
}

#Preview {
  VStack {
    MusiqwikView(
      pair: .init(
        startNote: .init(.C, accidental: .flat, octave: 3),
        endNote: .init(.C, accidental: .doubleSharp, octave: 4),
        category: .ascending,
        clef: .bass)
    )
    MusiqwikView(
      pair: .init(
        startNote: .init(.C, accidental: .doubleFlat, octave: 4),
        endNote: .init(.E, accidental: .sharp, octave: 4),
        category: .simultaneously,
        clef: .alto)
    )
    MusiqwikView(
      pair: .init(
        startNote: .init(.E, accidental: .sharp, octave: 4),
        endNote: .init(.E, accidental: .natural, octave: 4),
        category: .descending,
        clef: .treble)
    )
  }
}
