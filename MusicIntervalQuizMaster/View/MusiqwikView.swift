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
      let startNoteText = startNote.musiqwikText(clef: clef)
      let endNoteText = endNote.musiqwikText(clef: clef)
      
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
  }
}
