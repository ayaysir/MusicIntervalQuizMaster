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
  
  @AppStorage(.cfgTimerSeconds) var cfgTimerSeconds = 0
  
  @StateObject var viewModel = SettingViewModel()
  
  @State private var showAlert = false
  private let alert17 = AlertAppleMusic17View(title: "그룹에서 한 개 이상 선택", subtitle: "해당 그룹 중 한 개 이상 옵션은 반드시 선택되어야 합니다.", icon: .custom(UIImage(systemName: "exclamationmark.triangle.fill")!))
  
  var body: some View {
    NavigationStack {
      Form {
        NavigationLink {
          AppSettingView()
        } label: {
          Text("App 설정")
        }
        
        Section {
          Stepper(value: $cfgTimerSeconds, in: 0...60, step: 1) {
            HStack {
              Text("문제풀이 타이머")
              Spacer()
              Text(cfgTimerSeconds == 0 ? "제한없음" : "\(1)초")
                .foregroundColor(.gray)
            }
          }
        }
        
        Section {
          Toggle("복합 음정 (9도 이상)", isOn: $cfgIntervalFilterCompound)
          Toggle("겹증/겹감", isOn: $cfgIntervalFilterDoublyTritone)
          NavigationLink {
            IntervalTypeSelectSettingView()
              .environmentObject(viewModel)
          } label: {
            Text("음정 자세하게 선택하기 (\(viewModel.intervalStatesTurnOnCount)/\(viewModel.totalIntervalStatesCount))")
          }
        } header: {
          Text("심화 내용의 문제 포함 여부")
        } footer: {
          Text("복합 음정, 겹증/겹감을 문제에 포함시키려면 On 하세요. 세부 설정보다 우선합니다.")
        }

        Section {
          Toggle("상행", isOn: $cfgNotesAscending)
          Toggle("하행", isOn: $cfgNotesDescending)
          Toggle("동시", isOn: $cfgNotesSimultaneously)
        } header: {
          Text("음표 제시 방법")
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
          Text("출제 대상 음자리표")
        }
        
        
        Section {
          Toggle("♯ (Sharp)", isOn: $cfgAccidentalSharp)
          Toggle("♭ (Flat)", isOn: $cfgAccidentalFlat)
          Toggle("♯♯ (Double Sharp)", isOn: $cfgAccidentalDoubleSharp)
          Toggle("♭♭ (Double Flat)", isOn: $cfgAccidentalDoubleFlat)
        } header: {
          Text("출제 대상 임시표")
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .onChange(of: toggleStatesOfClefs) { _ in
        ensureAtLeastOneToggle(group: .clefs)
      }
      .onChange(of: toggleStatesOfDirections) { _ in
        ensureAtLeastOneToggle(group: .directions)
      }
      .alert("해당 섹션에서 반드시 한 개 이상 옵션이 선택되어야 합니다.", isPresented: $showAlert) {
        
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
