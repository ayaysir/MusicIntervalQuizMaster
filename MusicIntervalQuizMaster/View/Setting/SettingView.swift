//
//  SettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct SettingView: View {
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
  
  @StateObject var viewModel = SettingViewModel()
  
  @State private var showAlert = false
  
  private let alert17 = AlertAppleMusic17View(
    title: "alert_group_minimum_title".localized,
    subtitle: "alert_group_minimum_subtitle".localized,
    icon: .custom(UIImage(systemName: "exclamationmark.triangle.fill")!)
  )
  
  var body: some View {
    NavigationStack {
      Form {
        NavigationLink {
          AppSettingView()
        } label: {
          Text("app_settings")
        }
        
        Section {
          Toggle("toggle_compound_intervals", isOn: $cfgIntervalFilterCompound)
          Toggle("toggle_doubly_tritone", isOn: $cfgIntervalFilterDoublyTritone)
          NavigationLink {
            IntervalTypeSelectSettingView()
              .environmentObject(viewModel)
          } label: {
            Text("link_detailed_interval_selection")
            + Text(" (\(viewModel.intervalStatesTurnOnCount)/\(viewModel.totalIntervalStatesCount))")
          }
        } header: {
          Text("header_include_advanced_questions".localized)
        } footer: {
          Text("footer_advanced_question_description".localized)
        }

        Section {
          Toggle(IntervalPairDirection.ascending.localizedDescription, isOn: $cfgNotesAscending)
          Toggle(IntervalPairDirection.descending.localizedDescription, isOn: $cfgNotesDescending)
          Toggle(IntervalPairDirection.simultaneously.localizedDescription, isOn: $cfgNotesSimultaneously)
        } header: {
          Text("note_direction_presentation_method")
        }
        
        Section {
          Toggle(isOn: $cfgClefTreble) {
            HStack {
              let clef = Clef.treble
              Text("=\(clef.musiqwikText)=")
                .font(.custom("Musiqwik", size: 18))
              Text(clef.localizedDescription)
                .font(.footnote)
            }
          }
          
          Toggle(isOn: $cfgClefBass) {
            HStack {
              let clef = Clef.bass
              Text("=\(clef.musiqwikText)=")
                .font(.custom("Musiqwik", size: 18))
              Text(clef.localizedDescription)
                .font(.footnote)
            }
          }
          
          Toggle(isOn: $cfgClefAlto) {
            HStack {
              let clef = Clef.alto
              Text("=\(clef.musiqwikText)=")
                .font(.custom("Musiqwik", size: 18))
              Text(clef.localizedDescription)
                .font(.footnote)
            }
          }
        } header: {
          Text("clef_for_question")
        }
        
        
        Section {
          Toggle("♯  Sharp", isOn: $cfgAccidentalSharp)
          Toggle("♭  Flat", isOn: $cfgAccidentalFlat)
          Toggle("♯♯  Double Sharp", isOn: $cfgAccidentalDoubleSharp)
          Toggle("♭♭  Double Flat", isOn: $cfgAccidentalDoubleFlat)
        } header: {
          Text("accidental_for_question")
        }
      }
      .navigationTitle("settings")
      // .navigationBarTitleDisplayMode(.inline)
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

fileprivate enum SettingGroup {
  case directions, clefs
}

extension SettingView {
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
}

#Preview {
  SettingView()
}
