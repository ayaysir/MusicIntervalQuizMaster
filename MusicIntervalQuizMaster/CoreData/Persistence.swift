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
    
    func mockStat(intervalModifier: String, 
                  intervalNumber: Int,
                  myIntervalModifier: String,
                  myIntervalNumber: Int) -> Stat {
      let currentDate = Date.now
      let finalDate = currentDate.addingTimeInterval(Double.random(in: 5...30))
      
      return Stat(
        sessionId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
        sessionCreateTime: Date(),
        seq: 0,
        startTime: currentDate,
        timerLimit: 0,
        clef: ["treble", "bass", "alto"].randomElement()!,
        direction: ["asc", "dsc", "sml"].randomElement()!,
        startNoteLetter: "F",
        startNoteAccidental: "𝄫",
        startNoteOctave: 2,
        endNoteLetter: "G",
        endNoteAccidental: "𝄪",
        endNoteOctave: 3,
        intervalModifier: intervalModifier,
        intervalNumber: intervalNumber,
        firstTryTime: finalDate,
        finalAnswerTime: finalDate,
        isCorrect: intervalModifier == myIntervalModifier && intervalNumber == myIntervalNumber,
        tryCount: 5,
        myIntervalModifier: myIntervalModifier,
        myIntervalNumber: myIntervalNumber
      )
    }
    
    func generateRateStats(totalCount: Int, correctRate: Double) -> [Stat] {
      let modifiers = [
        "M", "m", "A", "d", "P",
                       // "dd", "AA",
      ]
      let numbers = Array(1...13)
      
      var stats: [Stat] = []
      
      for _ in 0..<totalCount {
        let intervalModifier = modifiers.randomElement()!
        let intervalNumber = numbers.randomElement()!
        
        let isCorrect = Double.random(in: 0...1) < correctRate
        let myIntervalModifier = isCorrect ? intervalModifier : modifiers.randomElement()!
        let myIntervalNumber = isCorrect ? intervalNumber : numbers.randomElement()!
        
        stats.append(mockStat(
          intervalModifier: intervalModifier,
          intervalNumber: intervalNumber,
          myIntervalModifier: myIntervalModifier,
          myIntervalNumber: myIntervalNumber
        ))
      }
      
      return stats
    }

    // 데이터 변환
    let stats: [Stat] = generateRateStats(totalCount: 1000, correctRate: 0.4)

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
      recordEntity.intervalModifier = stat.intervalModifier
      recordEntity.intervalNumber = Int16(stat.intervalNumber)
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
