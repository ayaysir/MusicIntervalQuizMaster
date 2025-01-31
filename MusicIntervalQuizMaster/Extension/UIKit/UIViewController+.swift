//
//  UIViewController+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 1/31/25.
//

import UIKit

extension UIViewController {
  /// 현재 표시된 최상위 뷰 컨트롤러 반환
  func getTopMostViewController() -> UIViewController {
    if let presentedViewController = self.presentedViewController {
      return presentedViewController.getTopMostViewController()
    } else if let navigationController = self as? UINavigationController {
      return navigationController.visibleViewController?.getTopMostViewController() ?? navigationController
    } else if let tabBarController = self as? UITabBarController {
      return tabBarController.selectedViewController?.getTopMostViewController() ?? tabBarController
    } else {
      return self
    }
  }
}
