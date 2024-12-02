//
//  Filter.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/2/24.
//

import Foundation

enum Filter: String, CaseIterable {
  case Quality, Degree, Solved
  
  var localizedDescription: String {
    switch self {
    case .Quality:
      "filter_menu_quality".localized
    case .Degree:
      "filter_menu_degree".localized
    case .Solved:
      "filter_menu_solved".localized
    }
  }
}
