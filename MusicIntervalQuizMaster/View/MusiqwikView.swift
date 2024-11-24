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
      let isSameNotePosition = startNote.octave == endNote.octave && startNote.letter == endNote.letter
      let isSameAndSimultaneous = isSameNotePosition && category == .simultaneously
      
      if category != .simultaneously || isSameAndSimultaneous {
        let startNoteText = startNote.musiqwikText(
          clef: clef,
          leftAccidental: startNote.accidental,
          rightAccidental: endNote.accidental
        )
        let endNoteText = endNote.musiqwikText(
          clef: clef,
          leftAccidental: startNote.accidental,
          rightAccidental: endNote.accidental,
          isSameNotePosition: isSameNotePosition
        )

        Text("'\(clef.musiqwikText)===\(startNoteText)\(isSameAndSimultaneous ? "" : "===")\(endNoteText)===\"")
          .font(.custom("Musiqwik", size: 50))
      } else {
        let left = "'\(clef.musiqwikText)====="
        let right = "=====\""
        
        let degree = abs(endNote.relativeNotePosition - startNote.relativeNotePosition)
        
        let isNeedSeparateNotes = degree <= 1
        let isNeedSeparateAccidentals = degree <= 2
        
        let startNoteText = startNote.musiqwikText(
          clef: clef,
          leftAccidental: startNote.accidental,
          rightAccidental: endNote.accidental,
          isForSimultaneousNotes: true,
          isNeedSeparateNotes: isNeedSeparateNotes,
          isNeedSeparateAccidentals: isNeedSeparateAccidentals
        )
        let endNoteText = endNote.musiqwikText(
          clef: clef,
          leftAccidental: startNote.accidental,
          rightAccidental: endNote.accidental,
          isForSimultaneousNotes: true, 
          isRightNote: true,
          isSameNotePosition: isSameNotePosition,
          isNeedSeparateNotes: isNeedSeparateNotes,
          isNeedSeparateAccidentals: isNeedSeparateAccidentals
        )
        // Text("\(degree)").offset(x: 100, y: -35)
        Text("\(left)\(startNoteText)\(right)")
          .font(.custom("Musiqwik", size: 50))
        Text("\(left)\(endNoteText)\(right)")
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
  ScrollView {
    VStack {
      MusiqwikView(
        pair: .init(
          startNote: .init(.B, accidental: .doubleFlat, octave: 3),
          endNote: .init(.D, accidental: .doubleSharp, octave: 4),
          category: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.F, accidental: .flat, octave: 5),
          endNote: .init(.G, accidental: .doubleSharp, octave: 5),
          category: .simultaneously,
          clef: .treble)
      )
      Divider()
      MusiqwikView(
        pair: .init(
          startNote: .init(.C, accidental: .flat, octave: 3),
          endNote: .init(.C, accidental: .doubleSharp, octave: 4),
          category: .ascending,
          clef: .bass)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.F, accidental: .sharp, octave: 4),
          endNote: .init(.E, accidental: .natural, octave: 4),
          category: .descending,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.G, accidental: .sharp, octave: 4),
          endNote: .init(.G, accidental: .natural, octave: 4),
          category: .descending,
          clef: .treble)
      )
      
      MusiqwikView(
        pair: .init(
          startNote: .init(.B, accidental: .flat, octave: 3),
          endNote: .init(.C, accidental: .flat, octave: 4),
          category: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.F, accidental: .sharp, octave: 4),
          endNote: .init(.G, accidental: .flat, octave: 4),
          category: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.C, accidental: .flat, octave: 4),
          endNote: .init(.E, accidental: .sharp, octave: 4),
          category: .simultaneously,
          clef: .alto)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.G, accidental: .sharp, octave: 4),
          endNote: .init(.C, accidental: .doubleFlat, octave: 5),
          category: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.G, accidental: .doubleFlat, octave: 4),
          endNote: .init(.C, accidental: .doubleFlat, octave: 5),
          category: .simultaneously,
          clef: .treble)
      )
    }
  }
}
