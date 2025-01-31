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
   
  @AppStorage(.moreInfoRemindeIsOn) var isReminderOn: Bool = false
  @AppStorage(.moreInfoReminderHour) var reminderHour: Int = 0
  @AppStorage(.moreInfoReminderMinute) var reminderMinute: Int = 0
  @State private var reminderDatePickerValue: Date = .now
  @State private var isNotiPermitted: Bool = false
  
  var body: some View {
    NavigationStack {
      Form {
#if DEBUG
        debugArea
#endif
        Section("reminder_noti_title") {
          Toggle("reminder_noti_toggle", isOn: $isReminderOn)
          DatePicker(
            "for_every_day",
            selection: $reminderDatePickerValue,
            displayedComponents: .hourAndMinute
          )
          .disabled(!isReminderOn)
          .opacity(isReminderOn ? 1 : 0.2)
            // .datePickerStyle(WheelDatePickerStyle())
            // .labelsHidden()
        }
        .onAppear {
          // isReminderOn이 켜져있으면 reminderHour, reminderMinute를 시 분이 반영된 Date 오브젝트를 reminderDatePickerValue에 할당
          if isReminderOn {
              let calendar = Calendar.current
              let components = DateComponents(hour: reminderHour, minute: reminderMinute)
              if let date = calendar.date(from: components) {
                reminderDatePickerValue = date
              }
            }
        }
        .onChange(of: isReminderOn) { newValue in
          Task {
            if await LocalNotiManager.shared.requestNotificationPermission() {
              if newValue {
                LocalNotiManager.shared.scheduleNoti(hour: reminderHour, minute: reminderMinute)
              } else {
                LocalNotiManager.shared.removeAllNoti()
              }
            }
          }
        }
        .onChange(of: reminderDatePickerValue) { newValue in
          let calendar = Calendar.current
          reminderHour = calendar.component(.hour, from: newValue)
          reminderMinute = calendar.component(.minute, from: newValue)
          
          if isReminderOn {
            LocalNotiManager.shared.removeAllNoti()
            LocalNotiManager.shared.scheduleNoti(hour: reminderHour, minute: reminderMinute)
          }
        }
        
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
  private func openAppStoreLink() {
    if let url = URL(string: "https://apps.apple.com/developer/id1578285460"), // 앱스토어 링크
       UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}

extension MoreInfoView {
  private var debugArea: some View {
    Group {
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
      NavigationLink {
        AppStoreScreenshotsView()
      } label: {
        Text("AppStore screenshots")
      }
    }
  }
}

#Preview {
  MoreInfoView()
}
