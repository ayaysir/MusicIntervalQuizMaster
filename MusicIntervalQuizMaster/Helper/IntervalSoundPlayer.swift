//
//  IntervalSoundPlayer.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 5/1/26.
//

import Foundation
import Tonic

final class IntervalSoundPlayer {
  static let shared = IntervalSoundPlayer()

  private var workItem: DispatchWorkItem?

  private init() {}

  func stop() {
    SoundManager.shared.stopAllSounds()
    workItem?.cancel()
  }

  func play(pair: IntervalPair) {
    stop()

    let qos = DispatchQoS.QoSClass.userInitiated

    switch pair.direction {
    case .ascending, .descending:
      DispatchQueue.global(qos: qos).async {
        pair.startNote.playSound()
      }

      let item = DispatchWorkItem {
        pair.endNote.playSound()
      }
      workItem = item

      DispatchQueue.global(qos: qos).asyncAfter(
        deadline: .now() + .milliseconds(1200),
        execute: item
      )

    case .simultaneously:
      DispatchQueue.global(qos: qos).async {
        pair.startNote.playSound()
        pair.endNote.playSound()
      }
    }
  }
}
