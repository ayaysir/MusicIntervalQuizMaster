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
  @State private var showMailCopied: Bool = false
  
  var body: some View {
    NavigationStack {
      Form {
#if DEBUG
        // DEBUG_DebugArea
#endif
        CSVSection
        
        Section("help_section_title") {
          NavigationLink("tutorial_guide") {
            TutorialGuideView()
          }
          AreaWhatsNewArchive
          NavigationLink("copyright_section_title") {
            LicenseView()
          }
        }
        
        SectionFeedback
      }
      .navigationTitle("more_info")
      .sheet(isPresented: $isShowingMailView) {
        MailRPView(
          recipientEmail: DEV_MAIL,
          subject: mailTitle,
          body: mailBody
        )
      }
      .alert(item: $alertItem) { item in
        Alert(title: Text("not_available".localized), message: Text(item.message), dismissButton: .default(Text("ok_button".localized)))
      }
      .alert(isPresent: $showMailCopied, view: mailCopiedToastView)
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
  
  @ViewBuilder private var AreaWhatsNewArchive: some View {
    let keys = Array(WhatsNewArchive.shared.archive.keys)
    ForEach(keys, id: \.self) { key in
      NavigationLink("[ver \(key)] \("loc.whats_new_archive".localized)") {
        WhatsNewView(marketingVersion: key, features: WhatsNewArchive.shared(key) ?? [])
      }
    }
  }
  
  @ViewBuilder private var SectionFeedback: some View {
    Section {
      Group {
        HStack {
          Button("send_email_to_developer") {
            if MailRPView.canSendMail {
              isShowingMailView = true
            } else {
              sendEmailExternally()
            }
          }
          Spacer()
          Button(action: {
            UIPasteboard.general.string = DEV_MAIL
            showMailCopied = true
          }) {
            Image(systemName: "doc.on.clipboard")
          }
          
        }
        Button("loc.request_app_review") {
          openExternalLink(urlString: "https://apps.apple.com/app/id\(APP_ID)?action=write-review")
        }
        Button("view_my_other_apps") {
          openExternalLink(urlString: "https://apps.apple.com/developer/id\(DEVELOPER_ID)")
        }
      }
      .buttonStyle(.plain)
      .tint(.primary)
    } header: {
      Text("feedback_and_more_header")
    } footer: {
      Text("app_version") + Text(verbatim: appVersionString)
    }
  }
  
  private var DEBUG_DebugArea: some View {
    Section {
      NavigationLink {
        AppStoreScreenshotsView()
      } label: {
        Text("AppStore screenshots")
      }
    } header: {
      Text("DEBUGGER")
    }
  }
}

extension MoreInfoView {
  private var mailTitle: String {
    "inquiry_subject".localized
  }
  
  private var mailBody: String {
    """
    - App Version: \(appVersion ?? "unknown")
    - OS Version: \(osVersion)
    - Device: \(UIDevice.modelName)
    
    \("inquiry_body".localized)
    """
  }
  
  private var mailCopiedToastView: BottomAlertView {
    return BottomAlertView(
      title: "메일 주소가 복사되었습니다.".localized,
      subtitle: DEV_MAIL,
      icon: .custom(.init(systemName: "mail.and.text.magnifyingglass")!)
    )
  }
  
}

extension MoreInfoView {
  private func openExternalLink(urlString: String) {
    // "https://apps.apple.com/developer/id1578285460"
    // "https://apps.apple.com/app/id<YOUR_APP_ID>?action=write-review"
    if let url = URL(string: urlString),
       UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }

  private func sendEmailExternally() {
    let encodedSubject = mailTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? mailTitle
    let encodedBody = mailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? mailBody

    let urlString = "mailto:\(DEV_MAIL)?subject=\(encodedSubject)&body=\(encodedBody)"
    openExternalLink(urlString: urlString)
  }
}

#Preview {
  MoreInfoView()
}
