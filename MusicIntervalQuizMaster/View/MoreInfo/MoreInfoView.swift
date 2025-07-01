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
  @State private var showAlertDeleteAll: Bool = false
  @State private var isNotiPermitted: Bool = false
  
  
  var body: some View {
    NavigationStack {
      Form {
#if DEBUG
        DEBUG_DebugArea
#endif
        CSVSection
        
        Section("help_section_title") {
          NavigationLink("tutorial_guide") {
            TutorialGuideView()
          }
        }
        
        Section("copyright_section_title") {
          NavigationLink("view_open_source_licenses") {
            LicenseView()
          }
        }
        
        Section {
          Button("send_email_to_developer") {
            if MailRPView.canSendMail {
              isShowingMailView = true
            } else {
              alertItem = AlertItem(message: "unable_to_send_email".localized)
            }
          }
          Button("view_my_other_apps") {
            openAppStoreLink()
          }
        } header: {
          Text("feedback_and_more_header")
        } footer: {
          Text("app_version") + Text(" \(appVersion ?? "unknown")")
        }
      }
      .navigationTitle("more_info")
      .sheet(isPresented: $isShowingMailView) {
        MailRPView(
          recipientEmail: "yoonbumtae@gmail.com",
          subject: "inquiry_subject".localized,
          body: """
          - App Version: \(appVersion ?? "unknown")
          - OS Version: \(osVersion)
          - Device: \(UIDevice.modelName)
          
          \("inquiry_body".localized)
          """
        )
      }
      .alert(item: $alertItem) { item in
        Alert(title: Text("not_available".localized), message: Text(item.message), dismissButton: .default(Text("ok_button".localized)))
      }
    }
  }
}
extension MoreInfoView {
  private var CSVSection: some View {
    Section {
      NavigationLink {
        CSVView()
      } label: {
        Text("csv_view")
      }
      
      Button("csv_delete_all") {
        showAlertDeleteAll = true
      }
      .foregroundStyle(.red)
    } header: {
      Text("csv_header")
    }
    .alert(
      "csv_delete_alert_title", isPresented: $showAlertDeleteAll) {
        Button(role: .destructive) {
          QuizSessionManager(context: PersistenceController.shared.container.viewContext).deleteAllSessions()
        } label: {
          Text("btn_del")
        }
      } message: {
        Text("csv_delete_alert_message")
      }
  }
  
  private var DEBUG_DebugArea: some View {
    Group {
      NavigationLink {
        AppStoreScreenshotsView()
      } label: {
        Text("AppStore screenshots")
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
