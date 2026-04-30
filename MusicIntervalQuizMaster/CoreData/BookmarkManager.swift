//
//  BookmarkManager.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 4/30/26.
//

import Foundation
import CoreData
import Tonic

class BookmarkManager {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  private func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print("Failed to save context: \(error.localizedDescription)")
      }
    }
  }
  
  private func findDuplicates(pair: IntervalPair, fetchLimit: Int = 1) -> NSFetchRequest<BookmarkIntervalEntity> {
    let fetchRequest: NSFetchRequest<BookmarkIntervalEntity> = BookmarkIntervalEntity.fetchRequest()
    
    fetchRequest.predicate = NSPredicate(
      format: """
      startNoteLetter == %@ AND
      startNoteAccidental == %@ AND
      startNoteOctave == %d AND
      endNoteLetter == %@ AND
      endNoteAccidental == %@ AND
      endNoteOctave == %d AND
      direction == %@ AND
      clef == %@
      """,
      pair.startNote.letter.description,
      pair.startNote.accidental.description,
      pair.startNote.octave,
      pair.endNote.letter.description,
      pair.endNote.accidental.description,
      pair.endNote.octave,
      pair.direction.dataDescription,
      pair.clef.dataDescription
    )
    
    fetchRequest.fetchLimit = 1
    
    return fetchRequest
  }
  
  /// 중복된 레코드 있는지 조사
  func isDuplicate(pair: IntervalPair) -> Bool {
    do {
      let count = try context.count(for: findDuplicates(pair: pair))
      return count > 0
    } catch {
      print("Failed to check duplicate: \(error.localizedDescription)")
      return false
    }
  }
  
  /// Create
  func addBookmark(pair: IntervalPair) -> Bool {
    if isDuplicate(pair: pair) {
      print("BoomarkManager: Duplicate pair\n\(pair)")
      return false
    }
    
    do {
      // BookmarkEntity 생성
      let bookmarkEntity = BookmarkIntervalEntity(context: context)
      
      bookmarkEntity.createdAt = .now
      bookmarkEntity.intervalModifier = pair.advancedInterval?.modifier.abbrDescription
      bookmarkEntity.intervalNumber = Int16(pair.advancedInterval?.number ?? 0)
      
      // IntervalPair 매핑 (각각 비교해서 전부 일치하면 동일한 레코드로 취급)
      bookmarkEntity.startNoteLetter = pair.startNote.letter.description
      bookmarkEntity.startNoteAccidental = pair.startNote.accidental.description
      bookmarkEntity.startNoteOctave = Int16(pair.startNote.octave)
      
      bookmarkEntity.endNoteLetter = pair.endNote.letter.description
      bookmarkEntity.endNoteAccidental = pair.endNote.accidental.description
      bookmarkEntity.endNoteOctave = Int16(pair.endNote.octave)
      
      bookmarkEntity.direction = pair.direction.dataDescription
      bookmarkEntity.clef = pair.clef.dataDescription
      
      // 저장
      try context.save()
      
      return true
    } catch {
      print("Failed to add record: \(error.localizedDescription)")
      
      return false
    }
  }
  
  /// Read All
  func readAll() -> [BookmarkIntervalEntity] {
    let fetchRequest: NSFetchRequest<BookmarkIntervalEntity> = BookmarkIntervalEntity.fetchRequest()
    
    // 최신순 정렬
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: "createdAt", ascending: false)
    ]
    
    do {
      return try context.fetch(fetchRequest)
    } catch {
      print("Failed to fetch records: \(error.localizedDescription)")
      return []
    }
  }
  
  /// Delete
  func delete(_ entity: BookmarkIntervalEntity) -> Bool {
    context.delete(entity)
    
    do {
      try context.save()
      return true
    } catch {
      print("Failed to delete record: \(error.localizedDescription)")
      return false
    }
  }
  
  /// Delete by IntervalPair
  func delete(pair: IntervalPair) -> Bool {
    do {
      let results = try context.fetch(findDuplicates(pair: pair, fetchLimit: 10))
      
      if results.isEmpty {
        return false
      }
      
      for entity in results {
        context.delete(entity)
      }
      
      try context.save()
      return true
    } catch {
      print("Failed to delete by pair: \(error.localizedDescription)")
      return false
    }
  }
  
}

