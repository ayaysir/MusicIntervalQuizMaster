//
//  SoundManager.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/24/24.
//

import AVFoundation

class SoundManager {
  static let shared = SoundManager()
  private var playersWithHash: [Int: AVAudioPlayer] = [:]
  
  init() {
    setupAudioSession()
    initSounds()
  }
  
  func playSound(midiNumber number: Int) {
    guard let player = playersWithHash[number] else {
      return
    }
    
    player.play()
  }
  
  func stopAllSounds() {
    playersWithHash.values.forEach {
      $0.stop()
      $0.currentTime = 0 // 위치를 처음으로 되돌려야 리셋
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


