//
//  AppSettingView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/27/24.
//

import SwiftUI

struct AppSettingView: View {
  // MARK: - View main
  
  @State private var reminderDatePickerValue: Date = .now
  @AppStorage(.moreInfoRemindeIsOn) var isReminderOn: Bool = false
  @AppStorage(.moreInfoReminderHour) var reminderHour: Int = 0
  @AppStorage(.moreInfoReminderMinute) var reminderMinute: Int = 0
  
  @AppStorage(.cfgHapticPressedIntervalKeyboard) var cfgHapicPressed = true
  @AppStorage(.cfgHapticAnswer) var cfgHapicAnswer = true
  @AppStorage(.cfgHapticWrong) var cfgHapicWrong = true
  @AppStorage(.cfgAppAutoNextMove) var cfgAppAutoNextMove = false
  @AppStorage(.cfgTimerSeconds) var cfgTimerSeconds = 0
  @AppStorage(.cfgAppAppearance) var cfgAppAppearance = 0
  
  var body: some View {
    NavigationStack {
      Form {
        SectionReminder
        SectionTimer
        SectionAutoMoveNext
        SectionHaptic
        SectionAppearance
      }
      .navigationTitle("app_settings")
      .onAppear {
        onAppearSetReminder()
      }
      .onChange(of: isReminderOn, perform: onChangeIsReminderOnAsync)
      .onChange(of: reminderDatePickerValue, perform: onChangeReminderDatePickerValue)
    }
  }
}

extension AppSettingView {
  // MARK: - View segments
  
  private var SectionTimer: some View {
    Section {
      if ProcessInfo.processInfo.isiOSAppOnMac {
        ForMacStepper(value: $cfgTimerSeconds, range: 0...60, step: 5) {
          StepperLabel
        }
      } else {
        Stepper(value: $cfgTimerSeconds, in: 0...60, step: 5) {
          StepperLabel
        }
      }
    } header: {
      Text("timer_problem_solving_within_limit")
    } footer: {
      Text("timer_limit_description")
    }
  }
  
  private var StepperLabel: some View {
    HStack {
      Text("problem_solving_timer")
      Spacer()
      Text(cfgTimerSeconds == 0 ? "unlimited".localized : "\(cfgTimerSeconds)\("time_second_abbr".localized)")
        .foregroundColor(.gray)
    }
  }
  
  private var SectionAutoMoveNext: some View {
    Section {
      Toggle("auto_move_to_next_problem_toggle", isOn: $cfgAppAutoNextMove)
    } header: {
      Text("auto_move_to_next_problem")
    }
  }
  
  private var SectionHaptic: some View {
    Section {
      Toggle("haptic_when_key_pressed", isOn: $cfgHapicPressed)
      Toggle("haptic_when_correct", isOn: $cfgHapicAnswer)
      Toggle("haptic_when_wrong", isOn: $cfgHapicWrong)
    } header: {
      Text("haptic_feedback".localized)
    }
  }
  
  private var SectionAppearance: some View {
    Section("appearance") {
      AppearanceButton("appearance_use_device_theme".localized, 0)
      AppearanceButton("appearance_light_theme".localized, 1)
      AppearanceButton("appearance_dark_theme".localized, 2)
    }
  }
  
  private func AppearanceButton(_ title: String, _ cfgValue: Int) -> some View {
    Button(action: {
      cfgAppAppearance = cfgValue
    }) {
      HStack {
        Text(title)
        Spacer()
        if cfgAppAppearance == cfgValue {
          Image(systemName: "checkmark")
            .foregroundColor(.blue) // 체크 표시 색상
        }
      }
    }
    .foregroundStyle(.foreground)
  }
  
  private var SectionReminder: some View {
    Section("reminder_noti_title") {
      Toggle("reminder_noti_toggle", isOn: $isReminderOn)
      DatePicker(
        "for_every_day",
        selection: $reminderDatePickerValue,
        displayedComponents: .hourAndMinute
      )
      .frame(height: 30)
      .disabled(!isReminderOn)
      .opacity(isReminderOn ? 1 : 0.2)
    }
  }
}

extension AppSettingView {
  // MARK: - State funcs
  
  /// isReminderOn이 켜져있으면 reminderHour, reminderMinute를 시 분이 반영된 Date 오브젝트를 reminderDatePickerValue에 할당
  func onAppearSetReminder() {
    if isReminderOn {
      let calendar = Calendar.current
      let components = DateComponents(hour: reminderHour, minute: reminderMinute)
      if let date = calendar.date(from: components) {
        reminderDatePickerValue = date
      }
    }
  }
  
  func onChangeIsReminderOnAsync(_: Any) {
    Task {
      if await LocalNotiManager.shared.requestNotificationPermission() {
        if isReminderOn {
          LocalNotiManager.shared.scheduleNoti(hour: reminderHour, minute: reminderMinute)
        } else {
          LocalNotiManager.shared.removeAllNoti()
        }
      } else if isReminderOn {
        InstantAlert.show(
          "no_alert_permission_title".localized,
          message: "no_alert_permission_detail".localized
        ) { _ in
          isReminderOn = false
        }
      }
    }
  }
  
  func onChangeReminderDatePickerValue(_: Any) {
    let calendar = Calendar.current
    reminderHour = calendar.component(.hour, from: reminderDatePickerValue)
    reminderMinute = calendar.component(.minute, from: reminderDatePickerValue)
    
    if isReminderOn {
      LocalNotiManager.shared.removeAllNoti()
      LocalNotiManager.shared.scheduleNoti(hour: reminderHour, minute: reminderMinute)
    }
  }
}

#Preview {
  AppSettingView()
}
