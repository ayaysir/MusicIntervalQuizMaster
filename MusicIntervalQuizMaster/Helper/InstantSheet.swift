//
//  InstantSheet.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 7/3/25.
//

import UIKit
import SwiftUI

struct InstantSheet {
  static func show(hostingView: some View) {
    DispatchQueue.main.async {
      guard let scene =  UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
        print(#function, "scene is nil.")
        return
      }
      
      guard let window = scene.windows.first(where: { $0.isKeyWindow }) else {
        print(#function, "window is nil.")
        return
      }
      
      guard let topVC = window.rootViewController?.getTopMostViewController() else {
        print(#function, "topVC is nil.")
        return
      }
      
      // SwiftUI 뷰를 UIKit에 얹기
      let hostingController = UIHostingController(rootView: hostingView)
      hostingController.modalPresentationStyle = .pageSheet // 또는 .formSheet, .automatic 등

      topVC.present(hostingController, animated: true, completion: nil)
    }
  }
}
