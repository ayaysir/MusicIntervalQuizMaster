//
//  Tonic.Letter+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/21/24.
//

import Tonic

extension Letter {
  var basePitch: Int {
      return [0, 2, 4, 5, 7, 9, 11][rawValue]
  }
}
