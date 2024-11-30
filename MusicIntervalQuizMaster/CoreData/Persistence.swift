//
//  Persistence.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import Foundation
import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentCloudKitContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "MusicIntervalQuizMaster")
    
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}

extension PersistenceController {
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext

    // Stat 데이터를 기반으로 초기화
    let stats: [Stat] = [
      Stat(sessionId: UUID(uuidString: "E5205A03-8CA7-4001-A883-4E3F3D6745C0")!,
           sessionCreateTime: Date(), seq: 0, startTime: Date(), timerLimit: 0,
           clef: "bass", direction: "asc", startNoteLetter: "F", startNoteAccidental: "𝄫",
           startNoteOctave: 2, endNoteLetter: "G", endNoteAccidental: "3",
           endNoteOctave: 3, firstTryTime: Date(), finalAnswerTime: Date(),
           isCorrect: false, tryCount: 5, myIntervalModifier: "AA", myIntervalNumber: 9),
      Stat(sessionId: UUID(uuidString: "E5205A03-8CA7-4001-A883-4E3F3D6745C0")!,
           sessionCreateTime: Date(), seq: 1, startTime: Date(), timerLimit: 0,
           clef: "treble", direction: "asc", startNoteLetter: "E", startNoteAccidental: "𝄪",
           startNoteOctave: 4, endNoteLetter: "F", endNoteAccidental: "5",
           endNoteOctave: 5, firstTryTime: Date(), finalAnswerTime: Date(),
           isCorrect: false, tryCount: 3, myIntervalModifier: "dd", myIntervalNumber: 9),
      Stat(sessionId: UUID(uuidString: "E5205A03-8CA7-4001-A883-4E3F3D6745C0")!,
           sessionCreateTime: Date(), seq: 2, startTime: Date(), timerLimit: 0,
           clef: "bass", direction: "asc", startNoteLetter: "F", startNoteAccidental: "𝄪",
           startNoteOctave: 2, endNoteLetter: "A", endNoteAccidental: "2",
           endNoteOctave: 2, firstTryTime: Date(), finalAnswerTime: Date(),
           isCorrect: false, tryCount: 2, myIntervalModifier: "d", myIntervalNumber: 3)
    ]

    // 첫 번째 세션 생성
    let sessionEntity = SessionEntity(context: viewContext)
    sessionEntity.id = stats.first?.sessionId
    sessionEntity.createTime = stats.first?.sessionCreateTime

    // 기록 추가
    for stat in stats {
      let recordEntity = QuestionRecordEntity(context: viewContext)
      recordEntity.seq = Int16(stat.seq)
      recordEntity.startTime = stat.startTime
      recordEntity.timerLimit = Int16(stat.timerLimit)
      recordEntity.clef = stat.clef
      recordEntity.direction = stat.direction
      recordEntity.startNoteLetter = stat.startNoteLetter
      recordEntity.startNoteAccidental = stat.startNoteAccidental
      recordEntity.startNoteOctave = Int16(stat.startNoteOctave)
      recordEntity.endNoteLetter = stat.endNoteLetter
      recordEntity.endNoteAccidental = stat.endNoteAccidental
      recordEntity.endNoteOctave = Int16(stat.endNoteOctave)
      recordEntity.firstTryTime = stat.firstTryTime
      recordEntity.finalAnswerTime = stat.finalAnswerTime
      recordEntity.isCorrect = stat.isCorrect
      recordEntity.tryCount = Int16(stat.tryCount)
      recordEntity.myIntervalModifier = stat.myIntervalModifier
      recordEntity.myIntervalNumber = Int16(stat.myIntervalNumber)
      recordEntity.session = sessionEntity
    }

    // 데이터 저장
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }

    return result
  }()
}
