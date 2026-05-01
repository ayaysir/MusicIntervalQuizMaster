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
        if searchKeyword.isEmpty {
          SectionDirection
          SectionClefAccidental
          // SectionClef
          // SectionAccidental
          SectionAdvancedInterval
          SectionIntervalTypeSelectAll
        }
        
        IntervalTypeSectionsArea
      }
      .navigationTitle("loc.shrink_settings")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            dismiss()
          } label: {
            if #available(iOS 26.0, *) {
              Image(systemName: "xmark")
            } else {
              Label("loc.close", systemImage: "xmark")
            }
          }
          .accessibilityLabel("loc.close")
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
          isSelected: cfgNotesAscending,
          selectedTintColor: .green
        ) { cfgNotesAscending.toggle() }
        ToggleButton(
          title: IntervalPairDirection.descending.localizedDescription,
          isSelected: cfgNotesDescending,
          selectedTintColor: .green
        ) { cfgNotesDescending.toggle() }
        ToggleButton(
          title: IntervalPairDirection.simultaneously.localizedDescription,
          isSelected: cfgNotesSimultaneously,
          selectedTintColor: .green
        ) { cfgNotesSimultaneously.toggle() }
      }
    } header: {
      Text("note_direction_presentation_method")
    }
  }
  
  private var SectionClefAccidental: some View {
    Section {
      VStack {
        AreaClef
        AreaAccidental
      }
    } header: {
      Text("loc.title.clef_accidental")
    }
  }
  
  private var AreaClef: some View {
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
  }
  
  private var AreaAccidental: some View {
    HStack {
      ToggleButton(
        title: "♯",
        textFontSize: 18,
        isSelected: cfgAccidentalSharp,
        selectedTintColor: .mint) {
          cfgAccidentalSharp.toggle()
        }
      ToggleButton(
        title: "♭",
        textFontSize: 18,
        isSelected: cfgAccidentalFlat,
        selectedTintColor: .mint) {
          cfgAccidentalFlat.toggle()
        }
      ToggleButton(
        title: "♯♯ (𝄪)",
        textFontSize: 18,
        isSelected: cfgAccidentalDoubleSharp,
        selectedTintColor: .mint) {
          cfgAccidentalDoubleSharp.toggle()
        }
      ToggleButton(
        title: "♭♭",
        textFontSize: 18,
        isSelected: cfgAccidentalDoubleFlat,
        selectedTintColor: .mint) {
          cfgAccidentalDoubleFlat.toggle()
        }
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
  
  private var SectionIntervalTypeSelectAll: some View {
    Section {
      VStack {
        Text("loc.select_all_intervals_in_degree")
          .foregroundStyle(.secondary)
          .font(.caption2)
          .frame(maxWidth: .infinity, alignment: .leading)
        ScrollView(.horizontal) {
          HStack {
            ToggleButton(
              title: "loc.all_intervals".localized,
              isSelected: true,
              selectedTintColor: .indigo) {
                viewModel.turnOnAllStates()
              }
            ForEach(1...13, id: \.self) { currentDegree in
              ToggleButton(
                title: "\(currentDegree)\(currentDegree.oridnalWithoutNumber)",
                isSelected: true,
                selectedTintColor: .purple.opacity(0.8)) {
                  viewModel.turnOnStates(keySuffix: currentDegree.description)
                }
            }
          }
      }
      }
      HStack {
        Button(action: {
          viewModel.toggleStatesForCoreList()
        }) {
          Text("loc_core_interval.button")
        }
        Spacer()
        Button(
          action: {
            let abbrListText = CORE_INTERVALS
              .map { $0.replacingOccurrences(of: "_", with: "") }
              .joined(separator: ", ")
            InstantAlert.show(
              "loc.core_interval.title".localized,
              message: "loc.core_interval.message".localizedFormat(abbrListText)
            )
        }) {
          Image(systemName: "info.circle")
            .foregroundStyle(.secondary)
        }
        .buttonStyle(.borderless) // List 안에서 충돌 방지
      }
      .tint(.primary)
    } header: {
      VStack (alignment: .leading){
        HStack {
          Text("select_interval_type")
            .bold()
          Text("|")
          Text("degree_settings")
        }
      }
      
    }
  }
  
  private var IntervalTypeSectionsArea: some View {
    ForEach(1...13, id: \.self) { currentDegree in
      let filteredModifiers = IntervalModifier
        .availableModifierList(of: currentDegree)
        .filter { modifier in
          let degreeText = "\(modifier.mediumLocalizedDescription) \(currentDegree)\(currentDegree.oridnalWithoutNumber)"
          let abbrText = "\(modifier.localizedAbbrDescription)\(currentDegree)"
          return isAvailableIntervalButton(
            degreeText: degreeText,
            abbrText: abbrText,
            modifier: modifier
          )
        }
      
      if !filteredModifiers.isEmpty {
        Section {
          LazyVGrid(columns: columns, spacing: columnsMargin) {
            ForEach(filteredModifiers, id: \.self) { modifier in
              let degreeText = "\(modifier.mediumLocalizedDescription) \(currentDegree)\(currentDegree.oridnalWithoutNumber)"
              let abbrText = "\(modifier.localizedAbbrDescription)\(currentDegree)"
              ToggleButtonForSelectInterval(
                degreeText: degreeText,
                abbrText: abbrText,
                isSelected: viewModel.binding(for: "\(modifier.abbrDescription)_\(currentDegree)")
              )
            }
          }
        } header: {
          Text("\(currentDegree)\(currentDegree.oridnalWithoutNumber)")
        }
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
    || modifier.localizedDescription
      .lowercased()
      .contains(searchKeyword.lowercased())
  }
}

#Preview {
  ShrinkedQuizSettingView()
}
