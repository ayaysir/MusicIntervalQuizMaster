//
//  NormalizeValue.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 7/1/25.
//

import Foundation

struct NormalizeValue<N: FloatingPoint> {
  var originalValue: N
  var normalizationBase: N

  var normalizedValue: N {
    originalValue / normalizationBase
  }
  
  func applyNormalized(to value: N) -> N {
    normalizedValue * value
  }
}
