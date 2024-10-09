//
//  GameCenterDashboardRepresentedView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import SwiftUI
import GameKit

// Game Center 대시보드를 표시하기 위한 UIViewControllerRepresentable 구조체
struct GameCenterDashboardRepresentedView: UIViewControllerRepresentable {
  typealias UIViewControllerType = UIViewController
  
  @Environment(\.presentationMode) var presentationMode
  
  func makeUIViewController(context: Context) -> UIViewController {
    let viewController = UIViewController()
    showGameCenterDashboard(on: viewController, context: context)
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
  
  // Game Center 대시보드 표시 함수
  private func showGameCenterDashboard(on viewController: UIViewController, context: Context) {
    guard GKLocalPlayer.local.isAuthenticated else {
      print("Game Center에 인증되지 않았습니다.")
      return
    }
    
    let gameCenterViewController = GKGameCenterViewController()
    gameCenterViewController.gameCenterDelegate = context.coordinator // 델리게이트 설정
    viewController.present(gameCenterViewController, animated: true, completion: nil)
  }
  
  // Coordinator 클래스 사용
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  class Coordinator: NSObject, GKGameCenterControllerDelegate {
    var parent: GameCenterDashboardRepresentedView
    
    init(_ parent: GameCenterDashboardRepresentedView) {
      self.parent = parent
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
      gameCenterViewController.dismiss(animated: true) {
        self.parent.presentationMode.wrappedValue.dismiss() // 대시보드를 닫고 SwiftUI Sheet도 닫음
      }
    }
  }
}
