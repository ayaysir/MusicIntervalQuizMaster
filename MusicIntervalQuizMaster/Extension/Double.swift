//
//  Double.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import Foundation

extension Double {
  var percentageStringWithoutMark: String {
    String(format: "%.0f%", self * 100)
  }
  
  var percentageString: String {
    percentageStringWithoutMark + "%"
  }
}
