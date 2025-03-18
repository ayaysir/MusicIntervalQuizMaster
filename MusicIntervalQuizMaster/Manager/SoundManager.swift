//
//  SoundManager.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/24/24.
//

import AVFoundation

class SoundManager {
  static let shared = SoundManager()
  private let starling = Starling()
  private var playersWithHash: [Int: AVAudioPlayer] = [:]
  
  private init() {
    setupAudioSession()
    initSounds()
  }
  
  /// 사운드를 재생
  ///
  /// - Parameter number: MIDI 노트 번호. 해당 번호에 매핑된 플레이어가 사운드를 재생합니다.
  func playSound(midiNumber number: Int) {
    starling.play("Piano_\(number)", allowOverlap: true)
  }
  
  /// 재생 중인 모든 사운드를 즉시 정지
  func stopAllSounds() {
    starling.stopAll()
  }
  
  /// 오디오 세션 초기화 및 설정
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
  
  /// 사운드를 Identifer에 할당하고, 로딩 및 플레이 준비
  func initSounds() {
    for number in 34...83 {
      guard let url = Bundle.main.url(
        forResource: "Piano_BPM60_4B2E_\(number)",
        withExtension: "mp3"
      ) else {
        print("ERROR: Sound file \(number) not found")
        return
      }
      
      starling.load(sound: url, for: "Piano_\(number)")
    }
  }
}


