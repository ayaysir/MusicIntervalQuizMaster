//
//  IntervalCalculatorView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 5/1/26.
//

import SwiftUI
import Tonic

// MARK: - Main
struct IntervalCalculatorView: View {
  @State private var clef: Clef = .treble
  
  @State private var startLetter: Letter = .C
  @State private var startAccidental: Accidental = .natural
  @State private var startOctave: Int = 0
  @State private var startOctaveRange: ClosedRange<Int> = 0...5
  
  @State private var endLetter: Letter = .C
  @State private var endAccidental: Accidental = .natural
  @State private var endOctave: Int = 0
  @State private var endOctaveRange: ClosedRange<Int> = 0...5
  
  @State private var showInfoSheet = false
  
  var startNote: Note {
    Note(startLetter, accidental: startAccidental, octave: startOctave)
  }
  var endNote: Note {
    Note(endLetter, accidental: endAccidental, octave: endOctave)
  }
  var intervalPair: IntervalPair {
    // .ascending으로 해도 잘 계산됨
    IntervalPair(startNote: startNote, endNote: endNote, direction: actualOrder, clef: clef)
  }
  var actualOrder: IntervalPairDirection {
    startNote.orthodoxPitch < endNote.orthodoxPitch ? .ascending : startNote.orthodoxPitch == endNote.orthodoxPitch ? .simultaneously : .descending
  }
  var actualOrderStringKey: LocalizedStringKey {
    switch actualOrder {
    case .ascending:
      "loc.calc.left_lower"
    case .descending:
      "loc.calc.right_lower"
    case .simultaneously:
      "loc.calc.same_note"
    }
  }
  var halfstepCount: Int {
    AdvancedInterval.halfsteps(startNote, endNote)
  }
  
  var body: some View {
    VStack {
      AreaClefPicker
      AreaMusiqiwkViewWithPlayButton
      AreaInfo
      Spacer()
        .frame(height: 20)
      AreaNoteSelectors
    }
    .padding(10)
    .navigationTitle("loc.calc.title")
    .navigationBarTitleDisplayMode(.large)
    .onAppear {
      initBothOctaveRanges()
    }
    .onChange(of: clef) { _ in
      initBothOctaveRanges()
    }
    .onChange(of: startLetter) { _ in
      let availableStartOctaveRange = clef.availableOctaveRange(of: startLetter)
      startOctaveRange = availableStartOctaveRange
      
      if startOctave > availableStartOctaveRange.upperBound {
        startOctave = availableStartOctaveRange.upperBound
      } else if startOctave < availableStartOctaveRange.lowerBound {
        startOctave = availableStartOctaveRange.lowerBound
      }
    }
    .onChange(of: endLetter) { _ in
      let availableEndOctaveRange = clef.availableOctaveRange(of: endLetter)
      endOctaveRange = availableEndOctaveRange
      
      if endOctave > availableEndOctaveRange.upperBound {
        endOctave = availableEndOctaveRange.upperBound
      } else if endOctave < availableEndOctaveRange.lowerBound {
        endOctave = availableEndOctaveRange.lowerBound
      }
      
      print(intervalPair)
    }
    .sheet(isPresented: $showInfoSheet) {
      IntervalInfoView(pair: intervalPair)
    }
  }
}

// MARK: - View elements (fragments)
extension IntervalCalculatorView {
  @ViewBuilder private func PickersNoteSelector(
    _ titleKey: LocalizedStringKey,
    letter: Binding<Letter>,
    accidental: Binding<Accidental>,
    octave: Binding<Int>,
    octaveRange: Binding<ClosedRange<Int>>
  ) -> some View {
    VStack {
      Text(titleKey)
        // .font(.subheadline)
        .bold()
        .foregroundStyle(.secondary)
      
      HStack {
        NoteSelectorRowHeader("loc.calc.letter")
        Spacer()
        NoteSelectorRowHeader("loc.calc.accidental")
        Spacer()
        NoteSelectorRowHeader("loc.calc.octave")
      }
      .padding(.horizontal, 5)
      
      HStack {
        Picker("loc.calc.letter", selection: letter) {
          Section {
            ForEach(Letter.allCases, id: \.self) { letter in
              Text(verbatim: "\(letter)")
                .tag(letter)
            }
          }
        }
        .pickerStyle(.wheel)
        Picker("loc.calc.accidental", selection: accidental) {
          Section {
            ForEach(Accidental.allCases, id: \.self) { accidental in
              let accidentalText = accidental == .natural ? "♮" : accidental.description
              Text(verbatim: "\(accidentalText)")
                .tag(accidental)
            }
          }
        }
        .pickerStyle(.wheel)
        Picker("loc.calc.octave", selection: octave) {
          Section {
            ForEach(octaveRange.wrappedValue, id: \.self) { octave in
              Text(verbatim: "\(octave)")
                .tag(octave)
            }
          
          }
        }
        .pickerStyle(.wheel)
      }
      .offset(y: -20)
    }
    .frame(maxWidth: .infinity)
  }
  
  @ViewBuilder private func NoteSelectorRowHeader(_ titleKey: LocalizedStringKey) -> some View {
    Text(titleKey)
    .padding(2.5)
    .font(.caption2).fontWeight(.semibold)
    .frame(height: 20)
    .frame(maxWidth: 200)
    .foregroundStyle(.bwBackground)
    .lineLimit(1)
    .minimumScaleFactor(0.1)
    .background(.secondary)
    .clipShape(RoundedRectangle(cornerRadius: 5))
  }
}

// MARK: - View elements (Group)
extension IntervalCalculatorView {
  @ViewBuilder private var AreaClefPicker: some View {
    Picker("loc.calc.clef", selection: $clef) {
      ForEach(Clef.allCases) { clef in
        Text(verbatim: clef.shortLocalizedDescription)
          .tag(clef)
      }
    }
    .pickerStyle(.segmented)
  }
  
  @ViewBuilder private var AreaMusiqiwkViewWithPlayButton: some View {
    ZStack(alignment: .bottom) {
      MusiqwikView(
        pair: .init(
          startNote: Note(startLetter, accidental: startAccidental, octave: startOctave),
          endNote: Note(endLetter, accidental: endAccidental, octave: endOctave),
          direction: .ascending,
          clef: clef
        )
      )
      .pickerStyle(.segmented)
      Button {
        IntervalSoundPlayer.shared.play(pair: intervalPair)
      } label: {
        Label("loc.info.listen", systemImage: "speaker.wave.3.fill")
      }
      .tint(.mint)
      .buttonStyle(.borderedProminent)
      .offset(y: 50)
    }
  }
  
  @ViewBuilder private var AreaInfo: some View {
    let background: Color = intervalPair.advancedInterval != nil ? .teal : .pink
    HStack(alignment: .firstTextBaseline) {
      if let advancedInterval = intervalPair.advancedInterval {
        VStack {
          Text(advancedInterval.localizedDescription)
            .font(.title3)
            .fontWeight(.semibold)
          Text(verbatim: "[\(startNote) - \(endNote)]")
            .font(.subheadline)
            .foregroundStyle(.primary.opacity(0.7))
        }
      } else {
        VStack {
          Image(systemName: "xmark.square.fill")
            .symbolRenderingMode(.multicolor)
          Text("loc.calc.unsupported_interval")
            .font(.caption)
        }
      }
      
      VStack {
        HStack {
          Spacer()
          Text(actualOrderStringKey)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        
        HStack {
          Spacer()
          Text("loc.calc.halfstep_count")
            .font(.subheadline)
            .foregroundStyle(.secondary)

          Text("\(halfstepCount)")
            .font(.title3)
            .fontWeight(.semibold)
        }
      }
      Spacer()
      if intervalPair.advancedInterval != nil {
        Button(action: {
          showInfoSheet.toggle()
        }) {
          VStack {
            Image(systemName: "text.page.badge.magnifyingglass")
            Text("loc.quiz.explain")
              .lineLimit(1)
              .minimumScaleFactor(0.5)
          }
        }
        .padding(4)
        .tint(.white)
        .background(.indigo.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.leading, 32)
    .padding(.trailing, 16)
    .padding(.vertical, 16)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(background.opacity(0.145))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 4)
    )
  }
  
  @ViewBuilder private var AreaNoteSelectors: some View {
    HStack(spacing: 0) {
      PickersNoteSelector(
        "loc.calc.start_note",
        letter: $startLetter,
        accidental: $startAccidental,
        octave: $startOctave,
        octaveRange: $startOctaveRange
      )
      
      Rectangle()
        .fill(.secondary)
        .frame(width: 1, height: 200)
      
      PickersNoteSelector(
        "loc.calc.end_note",
        letter: $endLetter,
        accidental: $endAccidental,
        octave: $endOctave,
        octaveRange: $endOctaveRange
      )
    }
  }
}

// MARK: - Init/View related methods/vars
extension IntervalCalculatorView {
  func initBothOctaveRanges() {
    let availableStartOctaveRange = clef.availableOctaveRange(of: startLetter)
    let availableEndOctaveRange = clef.availableOctaveRange(of: endLetter)
    
    startOctaveRange = availableStartOctaveRange
    endOctaveRange = availableEndOctaveRange
    
    if !(availableStartOctaveRange ~= startOctave) {
      startOctave = availableStartOctaveRange.lowerBound
    }
    
    if !(availableEndOctaveRange ~= endOctave) {
      endOctave = availableEndOctaveRange.lowerBound
    }
  }
}

// MARK: - Utility methods
extension IntervalCalculatorView {
  
}

// MARK: - #Preview
#Preview {
  NavigationStack {
    IntervalCalculatorView()
  }
}
