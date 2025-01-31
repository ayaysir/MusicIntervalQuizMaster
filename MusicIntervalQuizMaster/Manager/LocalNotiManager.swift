//
//  LocalNotiManager.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 1/31/25.
//

import UIKit

struct LocalNotiManager {
  static let shared = LocalNotiManager()
  
  let center = UNUserNotificationCenter.current()
  let calendar = Calendar.current
  
  func scheduleNoti() {
    let content = UNMutableNotificationContent()
    
    content.title = "noti_promo_title"
    
    // 알림이 등록될 날짜의 다음 날
    var currentDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    for _ in 0..<12 {
      var dateComponents = calendar.dateComponents(
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
            let day = dateComponents.day,
            let hour = dateComponents.hour,
            let minute = dateComponents.minute else { continue }
      
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      let uniqueIdentifier = "Noti_AppOpenPromotion_\(year)_\(month)_\(day)_\(hour)_\(minute)"
      let request = UNNotificationRequest(identifier: uniqueIdentifier, content: content, trigger: trigger)
      
      center.add(request) { error in
        if let error {
          print("알림 \(uniqueIdentifier) 등록 실패: \(error)")
          return
        }
        
        print("알림 \(uniqueIdentifier) 등록 성공: \(hour):\(minute) :: \(currentDate)")
      }
      
      // 다음 날로 이동
      currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
  }
  
  func removeAllNoti() {
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
  }
}
