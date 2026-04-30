//
//  MusiqwikView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/17/24.
//

import SwiftUI

extension IntervalPair {
  var minimumScaleFactor: CGFloat { 0.1 }
  
  func musiqwikVerbatimTextForCase1(isSameNotePosition: Bool, isSameAndSimultaneous: Bool, isFullLength: Bool = true) -> String {
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
    
    let spacer = isFullLength ? "===" : ""
    
    return "'\(clef.musiqwikText)\(spacer)\(startNoteText)\(isSameAndSimultaneous ? "" : spacer)\(endNoteText)\(spacer)\""
  }
  
  func musiqwikVerbatimTextForCase2(isSameNotePosition: Bool, isFullLength: Bool = true) -> (area1: String, area2: String) {
    let spacer = isFullLength ? "=====" : ""
    let left = "'\(clef.musiqwikText)\(spacer)"
    let right = "\(spacer)\""
    
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
    
    return ("\(left)\(startNoteText)\(right)", "\(left)\(endNoteText)\(right)")
  }
  
  func musiqwikSheetSwiftUIViewArea(isFullLength: Bool = true) -> some View {
    ZStack {
      let isSameNotePosition = startNote.octave == endNote.octave && startNote.letter == endNote.letter
      let isSameAndSimultaneous = isSameNotePosition && direction == .simultaneously
      
      if direction != .simultaneously || isSameAndSimultaneous {
        Text(
          verbatim: musiqwikVerbatimTextForCase1(
            isSameNotePosition: isSameNotePosition,
            isSameAndSimultaneous: isSameAndSimultaneous,
            isFullLength: isFullLength
          )
        )
        .font(.custom("Musiqwik", size: 50))
        .minimumScaleFactor(minimumScaleFactor)
      } else {
        let (area1, area2) = musiqwikVerbatimTextForCase2(
          isSameNotePosition: isSameNotePosition,
          isFullLength: isFullLength
        )
        Group {
          Text(verbatim: area1)
          Text(verbatim: area2)
        }
        .font(.custom("Musiqwik", size: 50))
        .minimumScaleFactor(minimumScaleFactor)
      }
    }
  }
  
  var musiqwikSheetArea: some View {
    musiqwikSheetSwiftUIViewArea(isFullLength: true)
  }
}

struct MusiqwikView: View {
  let pair: IntervalPair
  
  var body: some View {
    pair.musiqwikSheetArea
  }
}

struct MiniMusiqwikView: View {
  let pair: IntervalPair
  
  var body: some View {
    pair.musiqwikSheetSwiftUIViewArea(isFullLength: false)
  }
}

#Preview {
  ScrollView {
    VStack {
      MusiqwikView(
        pair: .init(
          startNote: .init(.B, accidental: .doubleFlat, octave: 3),
          endNote: .init(.D, accidental: .doubleSharp, octave: 4),
          direction: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.F, accidental: .flat, octave: 5),
          endNote: .init(.G, accidental: .doubleSharp, octave: 5),
          direction: .simultaneously,
          clef: .treble)
      )
      Divider()
      MusiqwikView(
        pair: .init(
          startNote: .init(.C, accidental: .flat, octave: 3),
          endNote: .init(.C, accidental: .doubleSharp, octave: 4),
          direction: .ascending,
          clef: .bass)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.F, accidental: .sharp, octave: 4),
          endNote: .init(.E, accidental: .natural, octave: 4),
          direction: .descending,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.G, accidental: .sharp, octave: 4),
          endNote: .init(.G, accidental: .natural, octave: 4),
          direction: .descending,
          clef: .treble)
      )
      
      MusiqwikView(
        pair: .init(
          startNote: .init(.B, accidental: .flat, octave: 3),
          endNote: .init(.C, accidental: .flat, octave: 4),
          direction: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.F, accidental: .sharp, octave: 4),
          endNote: .init(.G, accidental: .flat, octave: 4),
          direction: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.C, accidental: .flat, octave: 4),
          endNote: .init(.E, accidental: .sharp, octave: 4),
          direction: .simultaneously,
          clef: .alto)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.G, accidental: .sharp, octave: 4),
          endNote: .init(.C, accidental: .doubleFlat, octave: 5),
          direction: .simultaneously,
          clef: .treble)
      )
      MusiqwikView(
        pair: .init(
          startNote: .init(.G, accidental: .doubleFlat, octave: 4),
          endNote: .init(.C, accidental: .doubleFlat, octave: 5),
          direction: .simultaneously,
          clef: .treble)
      )
    }
  }
}
