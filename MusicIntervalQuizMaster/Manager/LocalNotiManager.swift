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

  }
  
  func removeAllNoti() {
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
  }
}
