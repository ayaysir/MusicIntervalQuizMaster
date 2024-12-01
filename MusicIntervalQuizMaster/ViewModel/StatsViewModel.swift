//
//  StatsViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import Foundation

final class StatsViewModel: ObservableObject {
  @Published var stats: [Stat] = []
  private var manager: QuizSessionManager = .init(context: PersistenceController.shared.container.viewContext)
  
  init(cdManager: QuizSessionManager? = nil) {
    if let cdManager {
      manager = cdManager
    }
    
    stats = manager.fetchAllStats()
  }
}
