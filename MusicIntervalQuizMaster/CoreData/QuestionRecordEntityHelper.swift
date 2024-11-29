//
//  QuestionRecordEntityHelper.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/29/24.
//

import CoreData

class QuestionRecordEntityHelper {
  private let context: NSManagedObjectContext?
  private let isForPreview: Bool
  
  init(isForPreview: Bool = false) {
    self.isForPreview = isForPreview
    
    context = !isForPreview ? PersistenceController.shared.container.viewContext : nil
  }
  
  // MARK: - Save
  private func saveContext() {
    guard let context else {
      return
    }
    
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print("Failed to save context: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - Fetch Records
  func fetchQuestionRecords() -> [QuestionRecordEntity] {
    guard !isForPreview, let context else {
      print("Error: Context is not available in preview mode.")
      return []
    }
    
    let fetchRequest: NSFetchRequest<QuestionRecordEntity> = QuestionRecordEntity.fetchRequest()
    
    do {
      // Fetch all records from Core Data
      let records = try context.fetch(fetchRequest)
      return records
    } catch {
      print("Error: Failed to fetch QuestionRecordEntity - \(error.localizedDescription)")
      return []
    }
  }

  func fetchSessionRecordsGroupedByUUID() -> [String: [QuestionRecordEntity]]? {
    guard !isForPreview, let context else {
      print("Error: Context is not available in preview mode.")
      return nil
    }
    
    let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
    
    do {
      // 세션 엔티티 가져오기
      let sessions = try context.fetch(fetchRequest)
      
      var groupedRecords: [String: [QuestionRecordEntity]] = [:]
      
      for session in sessions {
        // 세션의 uuid를 key로 사용하고, 해당 세션에 연결된 QuestionRecordEntity를 배열로 가져옴
        if let uuid = session.id?.uuidString {
          // 해당 세션에 연결된 QuestionRecordEntity 가져오기
          if let questionRecords = session.questionRecords as? Set<QuestionRecordEntity> {
            groupedRecords[uuid] = Array(questionRecords)
          }
        }
      }
      
      return groupedRecords
    } catch {
      print("Error fetching sessions: \(error)")
      return nil
    }
  }
  
  func deleteAllSessions() {
    guard let context else {
      print("Error: Context is not available.")
      return
    }
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SessionEntity.fetchRequest()
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try context.execute(batchDeleteRequest)
      print("All sessions deleted successfully.")
      saveContext()
    } catch {
      print("Failed to delete sessions: \(error.localizedDescription)")
    }
  }
}
