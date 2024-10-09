//
//  GameCenterViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 9/7/24.
//

import GameKit

class GameCenterViewModel: ObservableObject {
  @Published var isAuthenticated = false
  @Published var achievements = [GKAchievement]()
  
  func authenticateUser() {
    let localPlayer = GKLocalPlayer.local
    
    localPlayer.authenticateHandler = { viewController, error in
      if let viewController = viewController {
        // 로그인 뷰를 표시해야 할 경우
        UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
      } else if localPlayer.isAuthenticated {
        // 인증이 성공한 경우
        DispatchQueue.main.async {
          self.isAuthenticated = true
          self.loadAchievements()
        }
      } else {
        // 인증 실패 처리
        print("Game Center 인증 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
      }
    }
  }
  
  /// 리더보드에 점수 제출
  func reportScore(leaderboardID: String, score: Int) {
    GKLeaderboard.submitScore(
      score,
      context: 0,
      player: GKLocalPlayer.local,
      leaderboardIDs: [leaderboardID]) { error in
        if let error {
          print(error)
        }
        
        print("리더보드에 점수가 성공적으로 업데이트 되었습니다.")
      }
  }
  
  /// Game Center에서 업적 로드
  func loadAchievements() {
    GKAchievement.loadAchievements { [weak self] achievements, error in
      if let error {
        print("업적을 로드하는 동안 오류 발생: \(error.localizedDescription)")
        return
      }
      
      DispatchQueue.main.async {
        self?.achievements = achievements ?? []
      }
    }
  }
  
  /// 업적 달성 보고
  func reportAchievement(identifier: String, percentComplete: Double) {
    let achievement = GKAchievement(identifier: identifier)
    achievement.percentComplete = percentComplete
    achievement.showsCompletionBanner = true
    
    GKAchievement.report([achievement]) { error in
      if let error {
        print("업적 보고 실패: \(error.localizedDescription)")
        return
      }
      
      print("업적이 성공적으로 보고되었습니다.")
    }
  }
}
