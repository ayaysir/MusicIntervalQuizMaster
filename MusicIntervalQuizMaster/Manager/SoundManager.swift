//
//  SoundManager.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/24/24.
//

import AVFoundation

class SoundManager {
  static let shared = SoundManager()
  private var players: [AVAudioPlayer] = []
  
  init() {
    setupAudioSession()
  }
  
  func playSound(named soundName: String) {
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
      print("Sound file not found")
      return
    }
    
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.play()
      players.append(player)
    } catch {
      print("Error playing sound: \(error.localizedDescription)")
    }
  }
  
  func stopAllSounds() {
    players.forEach { player in
      player.stop()
    }
  }
  
  func cleanupFinishedPlayers() {
    players = players.filter { $0.isPlaying }
  }
  
  func setupAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      // 설정: 무음 모드에서도 재생, 다른 앱의 소리와 믹싱 허용
      try audioSession.setCategory(
        .playback,                 // 무음 모드에서도 소리 재생
        mode: .default,            // 기본 오디오 모드
        options: [.mixWithOthers]  // 다른 앱의 사운드와 섞이도록 설정
      )
      try audioSession.setActive(true)
    } catch {
      print("Failed to configure audio session: \(error)")
    }
  }
}


