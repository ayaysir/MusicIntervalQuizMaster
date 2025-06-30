//
//  ShrinkedQuizSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 6/30/25.
//

import SwiftUI

fileprivate enum SettingGroup {
  case directions, clefs
}

struct ShrinkedQuizSettingView: View {
  // MARK: - Main States
  
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel = SettingViewModel()
  @State private var showAlert = false
  @State private var searchKeyword = ""
  
  // MARK: - LazyVGrid Variables
  
  let columnsCount: Int = 3
  let columnsMargin: CGFloat = 10
  
  // 화면을 그리드형식으로 꽉채워줌
  var columns: [GridItem] {
    (1...columnsCount).map { _ in GridItem(.flexible(), spacing: columnsMargin) }
  }
  
  // MARK: - App Storage (Quiz Config)
  
  @AppStorage(.cfgNotesAscending) var cfgNotesAscending = true
  @AppStorage(.cfgNotesDescending) var cfgNotesDescending = true
  @AppStorage(.cfgNotesSimultaneously) var cfgNotesSimultaneously = true
  
  @AppStorage(.cfgClefTreble) var cfgClefTreble = true
  @AppStorage(.cfgClefBass) var cfgClefBass = true
  @AppStorage(.cfgClefAlto) var cfgClefAlto = true
  
  @AppStorage(.cfgAccidentalSharp) var cfgAccidentalSharp = true
  @AppStorage(.cfgAccidentalFlat) var cfgAccidentalFlat = true
  @AppStorage(.cfgAccidentalDoubleSharp) var cfgAccidentalDoubleSharp = false
  @AppStorage(.cfgAccidentalDoubleFlat) var cfgAccidentalDoubleFlat = false
  
  @AppStorage(.cfgIntervalFilterCompound) var cfgIntervalFilterCompound = false
  @AppStorage(.cfgIntervalFilterDoublyTritone) var cfgIntervalFilterDoublyTritone = false
  
  // MARK: - Main Body
  
  var body: some View {
    NavigationStack {
      Form {
        SectionDirection
        SectionClef
        SectionAccidental
        SectionAdvancedInterval
        IntervalTypeTitleArea
        IntervalTypeSectionsArea
      }
      .navigationTitle("loc.shrink_settings")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("loc.close") {
            dismiss()
          }
        }
      }
      .searchable(text: $searchKeyword, prompt: "search_prompt")
      .onChange(of: toggleStatesOfClefs) { _ in
        ensureAtLeastOneToggle(group: .clefs)
      }
      .onChange(of: toggleStatesOfDirections) { _ in
        ensureAtLeastOneToggle(group: .directions)
      }
      .alert("alert_group_minimum_subtitle", isPresented: $showAlert) {
      }
    }
    
  }
}

extension ShrinkedQuizSettingView {
  // MARK: - View Segments
  
  private var SectionDirection: some View {
    Section {
      HStack {
        ToggleButton(
          title: IntervalPairDirection.ascending.localizedDescription,
          isSelected: cfgNotesAscending
        ) { cfgNotesAscending.toggle() }
        ToggleButton(
          title: IntervalPairDirection.descending.localizedDescription,
          isSelected: cfgNotesDescending
        ) { cfgNotesDescending.toggle() }
        ToggleButton(
          title: IntervalPairDirection.simultaneously.localizedDescription,
          isSelected: cfgNotesSimultaneously
        ) { cfgNotesSimultaneously.toggle() }
      }
    } header: {
      Text("note_direction_presentation_method")
    }
  }
  
  private var SectionClef: some View {
    Section {
      HStack {
        ToggleButton(
          title: Clef.treble.localizedDescription,
          musiqwikText: Clef.treble.musiqwikTextWithSpace,
          isSelected: cfgClefTreble) {
            cfgClefTreble.toggle()
          }
        ToggleButton(
          title: Clef.bass.localizedDescription,
          musiqwikText: Clef.bass.musiqwikTextWithSpace,
          isSelected: cfgClefBass) {
            cfgClefBass.toggle()
          }
        ToggleButton(
          title: Clef.alto.localizedDescription,
          musiqwikText: Clef.alto.musiqwikTextWithSpace,
          isSelected: cfgClefAlto) {
            cfgClefAlto.toggle()
          }
      }
    } header: {
      Text("clef_for_question")
    }
  }
  
  private var SectionAccidental: some View {
    Section {
      HStack {
        ToggleButton(
          title: "♯",
          textFontSize: 18,
          isSelected: cfgAccidentalSharp) {
            cfgAccidentalSharp.toggle()
          }
        ToggleButton(
          title: "♭",
          textFontSize: 18,
          isSelected: cfgAccidentalFlat) {
            cfgAccidentalFlat.toggle()
          }
        ToggleButton(
          title: "♯♯",
          textFontSize: 18,
          isSelected: cfgAccidentalDoubleSharp) {
            cfgAccidentalDoubleSharp.toggle()
          }
        ToggleButton(
          title: "♭♭",
          textFontSize: 18,
          isSelected: cfgAccidentalDoubleFlat) {
            cfgAccidentalDoubleFlat.toggle()
          }
      }
    } header: {
      Text("accidental_for_question")
    }
  }
  
  private var SectionAdvancedInterval: some View {
    Section {
      Toggle("toggle_compound_intervals", isOn: $cfgIntervalFilterCompound)
      Toggle("toggle_doubly_tritone", isOn: $cfgIntervalFilterDoublyTritone)
    } header: {
      Text("header_include_advanced_questions".localized)
    } footer: {
      Text("footer_advanced_question_description".localized)
    }
  }
  
  private var IntervalTypeTitleArea: some View {
    Section {} header: {
      VStack {
        Divider()
        HStack {
          Text("select_interval_type")
            .font(.title3)
            .bold()
          Text("degree_settings")
        }
        Divider()
      }
    }
  }
  
  private var IntervalTypeSectionsArea: some View {
    ForEach(1...13, id: \.self) { currentDegree in
      Section {
        LazyVGrid(columns: columns, spacing: columnsMargin) {
          ForEach(IntervalModifier.availableModifierList(of: currentDegree), id: \.self) { modifier in
            let degreeText = "\(modifier.localizedDescription) \(currentDegree)\(currentDegree.oridnalWithoutNumber)"
            let abbrText = "\(modifier.localizedAbbrDescription)\(currentDegree)"
            
            if isAvailableIntervalButton(
              degreeText: degreeText,
              abbrText: abbrText,
              modifier: modifier) {
              ToggleButtonForSelectInterval(
                degreeText: degreeText,
                abbrText: abbrText,
                isSelected: viewModel.binding(for: "\(modifier.abbrDescription)_\(currentDegree)")
              )
            }
          }
        }
      } header: {
        Text("\(currentDegree)\(currentDegree.oridnalWithoutNumber)")
      }
    }
  }
}

extension ShrinkedQuizSettingView {
  // MARK: - Other funcs
  
  private var toggleStatesOfDirections: [Bool] {
    [cfgNotesAscending, cfgNotesDescending, cfgNotesSimultaneously]
  }
  
  private var toggleStatesOfClefs: [Bool] {
    [cfgClefAlto, cfgClefBass, cfgClefTreble]
  }
  
  private func ensureAtLeastOneToggle(group: SettingGroup) {
    switch group {
    case .directions:
      if toggleStatesOfDirections.allSatisfy({ !$0 }) {
        showAlert = true
        cfgNotesAscending = true
      }
    case .clefs:
      if toggleStatesOfClefs.allSatisfy({ !$0 }) {
        showAlert = true
        cfgClefTreble = true
      }
    }
  }
  
  private func isAvailableIntervalButton(
    degreeText: String,
    abbrText: String,
    modifier: IntervalModifier
  ) -> Bool {
    searchKeyword.isEmpty
    || degreeText
      .lowercased()
      .contains(searchKeyword.lowercased())
    || abbrText
      .lowercased()
      .contains(searchKeyword.lowercased())
    || modifier.description
      .lowercased()
      .contains(searchKeyword.lowercased())
  }
}

#Preview {
  ShrinkedQuizSettingView()
}
