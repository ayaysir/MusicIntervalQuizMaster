//
//  LocalNotiManager.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 1/31/25.
//

import UIKit

struct LocalNotiManager {
  static let shared = LocalNotiManager()
  private init() {}
  
  let center = UNUserNotificationCenter.current()
  let calendar = Calendar.current
  
  func scheduleNoti(hour: Int, minute: Int) {
    let content = UNMutableNotificationContent()
    
    content.title = "noti_promo_title".localized
    content.sound = .default
    
    let now = Date()
    var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
    components.hour = hour
    components.minute = minute
      
    let scheduledTime = Calendar.current.date(from: components)!
      
    // 현재 시간이 설정된 시간보다 뒤라면 하루 더하기
    var currentDate = scheduledTime > now ? scheduledTime : Calendar.current.date(byAdding: .day, value: 1, to: scheduledTime)!
    
    for _ in 0..<12 {
      let dateComponents = calendar.dateComponents(
        [
          .year,
          .month,
          .day,
          .hour,
          .minute,
          .weekday
        ],
        from: currentDate
      )
      
      guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else {
        continue
      }
      
      let pair = QuizHelper.shared.generateRandomIntervalPair()
      guard let startNote = pair?.startNote,
            let endNote = pair?.endNote,
            let intervalLocalDesc = pair?.advancedInterval?.localizedDescription else {
        continue
      }
      
      content.body = """
      \("local_noti_body_1".localized) 
      \("local_noti_body_2".localizedFormat(startNote.description, endNote.description))
      \("local_noti_body_3".localizedFormat(intervalLocalDesc))
      \("local_noti_body_4".localized)
      """
      
      if let pair, let data = try? JSONEncoder().encode(pair) {
        content.userInfo = [String.keyUserInfoIntervalPair: data]
      }
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      let uniqueIdentifier = "Noti_AppOpenPromotion_\(year)_\(month)_\(day)_\(hour)_\(minute)"
      let request = UNNotificationRequest(identifier: uniqueIdentifier, content: content, trigger: trigger)
      
      // let currentBody = content.body
      // let dateString = {
      //   let formatter = ISO8601DateFormatter()
      //   formatter.timeZone = Calendar.current.timeZone
      //   return formatter.string(from: currentDate)
      // }()
      // let notiRegisterState = "알림 \(uniqueIdentifier) 등록 성공: \(hour):\(minute) :: \(dateString) :: \(currentBody)"
      
      center.add(request) { error in
        if let error {
          print("알림 \(uniqueIdentifier) 등록 실패: \(error)")
          return
        }
        
        // print(notiRegisterState)
        print("알림 \(uniqueIdentifier) 등록 성공: \(hour):\(minute)")
      }
      
      // 다음 날로 이동
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
  }
  
  func removeAllNoti() {
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
  }
  
  func requestNotificationPermission() async -> Bool {
    await withCheckedContinuation { continuation in
      let center = UNUserNotificationCenter.current()
      
      center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
          print("알림 권한 요청 실패: \(error.localizedDescription)")
        }
        continuation.resume(returning: granted)
      }
    }
  }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
  
  static let shared = NotificationDelegate()

  var onReceive: (([AnyHashable: Any]) -> Void)?
  var pendingUserInfo: [AnyHashable: Any]?

  // 앱 실행 중 (foreground)
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner,])
  }

  // 알림 클릭
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {

    let userInfo = response.notification.request.content.userInfo

    if let onReceive {
      // 앱 실행 중(또는 백그라운드에서 복귀시)인 경우
      onReceive(userInfo)
    } else {
      // 콜드 스타트인 경우
      pendingUserInfo = userInfo
    }

    completionHandler()
  }
}
