//
//  MoreInfoView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct MoreInfoView: View {
  var body: some View {
    NavigationStack {
      Form {
        Section("도움말") {
          NavigationLink("튜토리얼 가이드") {
            Text("")
          }
        }
        
        Section("저작권 정보") {
          NavigationLink("오픈 소스 저작권 보기") {
            ScrollView {
              VStack(alignment: .leading) {
                Text("MusiQwik")
                  .font(.title2).bold()
                Text("Copyright (c) 2001, 2008 by Robert Allgeyer. SIL Open Font License.")
                Divider()
                Text("Tonic")
                  .font(.title2).bold()
                Text("MIT license")
                Link("https://www.audiokit.io/Tonic", destination: URL(string: "https://www.audiokit.io/Tonic/")! )
                Divider()
                Text("AlertKit")
                  .font(.title2).bold()
                Text("MIT license")
                Link("https://github.com/sparrowcode/AlertKit", destination: URL(string: "https://github.com/sparrowcode/AlertKit")! )
                Divider()
                Spacer()
              }
              .padding(.horizontal, 20)
            }
            .navigationTitle("오픈 소스 저작권 보기")
            // .navigationBarTitleDisplayMode(.inline)
          }
        }
        
        Section {
          Button("개발자에게 이메일 보내기") {}
          Button("App Store에서 유용한 다른 앱 더 보기") {}
        } header: {
          Text("피드백 및 더 보기")
        } footer: {
          let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
          Text("APP VERSION: \(appVersion ?? "unknown")")
          
        }
      }
      .navigationTitle("More Info")
    }
  }
}

#Preview {
  MoreInfoView()
}
