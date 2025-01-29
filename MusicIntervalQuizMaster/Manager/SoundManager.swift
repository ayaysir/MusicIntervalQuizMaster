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
  private var playersWithHash: [Int: AVAudioPlayer] = [:]
  
  init() {
    setupAudioSession()
    initSounds()
  }
  
  func playSound(midiNumber number: Int) {
    playersWithHash[number]?.play()
  }
  
  func stopAllSounds() {
    players.forEach { player in
      if player.isPlaying {
        player.stop()
      }
    }
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
  
  func initSounds() {
    for number in 34...83 {
      guard let url = Bundle.main.url(
        forResource: "Piano_BPM60_4B2E_\(number)",
        withExtension: "mp3"
      ) else {
        print("Sound file not found")
        return
      }
      
      do {
        let player = try AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        playersWithHash[number] = player
      } catch {
        print("Error playing sound: \(error.localizedDescription)")
      }
    }
  }
}


