//
//  MoreInfoView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct MoreInfoView: View {
  @State private var isShowingMailView = false
  @State private var alertItem: AlertItem? = nil
  
  var body: some View {
    NavigationStack {
      Form {
        #if DEBUG
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
        #endif
        
        Section("Help") {
          NavigationLink("Tutorial Guide") {
            TutorialGuideView()
          }
        }

        Section("Copyright Information") {
          NavigationLink("View Open Source Licenses") {
            LicenseView()
          }
        }

        Section {
          Button("Send Email to Developer") {
            if MailRPView.canSendMail {
              isShowingMailView = true
            } else {
              alertItem = AlertItem(message: "Unable to send email. Please set up your email account.")
            }
          }
          Button("View My Other Useful Apps") {
            openAppStoreLink()
          }
        } header: {
          Text("Feedback & More")
        } footer: {
          Text("APP VERSION: \(appVersion ?? "unknown")")
        }
      }
      .navigationTitle("More Info")
      .sheet(isPresented: $isShowingMailView) {
        MailRPView(
          recipientEmail: "yoonbumtae@gmail.com",
          subject: "Inquiry About the Interval Quiz App",
          body: """
          - App Version: \(appVersion ?? "unknown")
          - OS Version: \(osVersion)
          - Device: \(UIDevice.modelName)
          
          Please write your inquiries or feedback.
          """
        )
      }
      .alert(item: $alertItem) { item in
        Alert(title: Text("Not available."), message: Text(item.message), dismissButton: .default(Text("OK")))
      }
    }
  }
}

extension MoreInfoView {
  private func openAppStoreLink() {
    if let url = URL(string: "https://apps.apple.com/developer/id1578285460"), // 앱스토어 링크
       UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}

#Preview {
  MoreInfoView()
}
