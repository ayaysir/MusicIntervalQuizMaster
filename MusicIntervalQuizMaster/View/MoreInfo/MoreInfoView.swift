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
        NavigationLink {
          ScrollView {
            let text = QuizSessionManager(context: PersistenceController.shared.container.viewContext).fetchAllStatsAsCSV()
            Text(text)
              .font(.system(size: 7))
              .onTapGesture {
                UIPasteboard.general.string = text
              }
          }
          .toolbar {
            ToolbarItem {
              Button("delete") {
                QuizSessionManager(context: PersistenceController.shared.container.viewContext).deleteAllSessions()
              }
            }
          }
        } label: {
          Text("View Logs")
        }
        
        Section("도움말") {
          NavigationLink("튜토리얼 가이드") {
            TutorialGuideView()
          }
        }
        
        Section("저작권 정보") {
          NavigationLink("오픈 소스 저작권 보기") {
            LicenseView()
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
