//
//  MoreInfoView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct MoreInfoView: View {
  var recordHelper = QuestionRecordEntityCreateHelper()
  
  var body: some View {
    NavigationStack {
      Form {
        Section("도움말") {
          NavigationLink("튜토리얼 가이드") {
            TutorialGuideView()
          }
        }
        
        Section("데이터") {
          NavigationLink("CSV 다운로드") {
            ScrollView {
              let _ = print(recordHelper.readAsCSV())
              TextEditor(text: .constant(recordHelper.readAsCSV()))
                .font(.system(size: 7))
            }
            .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                  QuestionRecordEntityHelper().deleteAllSessions()
                }) {
                  Image(systemName: "gearshape") // 아이콘
                    .font(.title2)
                }
              }
            }
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
  MoreInfoView(recordHelper: .init(isForPreview: true))
}
