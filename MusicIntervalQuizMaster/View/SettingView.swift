//
//  SettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/19/24.
//

import SwiftUI

struct AppSettingView: View {
  @AppStorage(.cfgHapticPressedIntervalKeyboard) var cfgHapicPressed = true
  @AppStorage(.cfgHapticAnswer) var cfgHapicAnswer = true
  @AppStorage(.cfgHapticWrong) var cfgHapicWrong = true
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          Toggle("음정 키보드를 누를 때", isOn: $cfgHapicPressed)
          Toggle("정답일 때", isOn: $cfgHapicAnswer)
          Toggle("오답일 때", isOn: $cfgHapicWrong)
        } header: {
          Text("햅틱")
        }
      }
    }
  }
}

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
  
  @StateObject var viewModel = SettingViewModel()
  
  var body: some View {
    NavigationStack {
      Form {
        NavigationLink {
          AppSettingView()
        } label: {
          Text("App 설정")
        }
        
        Section {
          NavigationLink {
            IntervalTypeSelectSettingView()
              .environmentObject(viewModel)
          } label: {
            Text("선택하기 (\(viewModel.intervalStatesTurnOnCount)/\(viewModel.totalIntervalStatesCount))")
          }
        } header: {
          Text("출제 대상 음정 종류 선택")
        }

        Section {
          Toggle("동시", isOn: $cfgNotesAscending)
          Toggle("상행", isOn: $cfgNotesDescending)
          Toggle("하행", isOn: $cfgNotesSimultaneously)
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
    }
  }
}

#Preview {
  SettingView()
}
