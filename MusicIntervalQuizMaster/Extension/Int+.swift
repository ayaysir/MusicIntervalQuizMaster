//
//  Int+.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import Foundation

extension Int {
  var ordinal: String {
    return "\(self)\(self.oridnalWithoutNumber)"
  }
  
  var oridnalWithoutNumber: String {
    let suffix: String
    let ones = self % 10
    let tens = (self / 10) % 10

    if tens == 1 {
      suffix = "degree_ordinal_th".localized
    } else {
      switch ones {
      case 1: suffix = "degree_ordinal_st".localized
      case 2: suffix = "degree_ordinal_nd".localized
      case 3: suffix = "degree_ordinal_rd".localized
      default: suffix = "degree_ordinal_th".localized
      }
    }
    
    return "\(suffix)"
  }
}
