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
  
  func playSound(named soundName: String) {
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
      print("Sound file not found")
      return
    }
    
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      players.append(player)
      player.play()
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
}


