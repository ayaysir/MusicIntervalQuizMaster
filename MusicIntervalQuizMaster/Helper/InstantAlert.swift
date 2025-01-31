//
//  InstantAlert.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 1/31/25.
//

import UIKit

struct InstantAlert {
  static func show(
    _ title: String,
    message: String? = nil,
    preferredStyle: UIAlertController.Style = .alert,
    completionHandler: ((UIAlertAction) -> Void)? = nil
  ) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: "OK".localized,
      style: .default,
      handler: completionHandler
    )
    alert.addAction(alertAction)
    
    DispatchQueue.main.async {
      if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
         let window = scene.windows.first(where: { $0.isKeyWindow }),
         let topViewController = window.rootViewController?.getTopMostViewController() {
        topViewController.present(alert, animated: true, completion: nil)
      }
    }
  }
}
