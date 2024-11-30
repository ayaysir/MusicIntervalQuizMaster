//
//  Tonic.Accidental+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/26/24.
//

import Tonic

extension Accidental {
  var adjustValue: Int {
    switch self {
    case .doubleFlat:
      -2
    case .flat:
      -1
    case .natural:
      0
    case .sharp:
      1
    case .doubleSharp:
      2
    }
  }
}
