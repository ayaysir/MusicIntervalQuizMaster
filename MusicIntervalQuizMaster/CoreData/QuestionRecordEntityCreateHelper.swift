//
//  QuestionRecordEntityCreateHelper.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/29/24.
//

import Foundation
import CoreData
import Tonic

class QuestionRecordEntityCreateHelper {
  private let context: NSManagedObjectContext?
  private let isForPreview: Bool
  
  init(isForPreview: Bool = false) {
    self.isForPreview = isForPreview
    
    if !isForPreview {
      context = PersistenceController.shared.container.viewContext
      currentSession = .init(context: context!)
      currentSession?.createTime = .now
    } else {
      context = nil
      currentSession = nil
    }
    
  }
  
  // MARK: - 3-step entry
  private var currentSession: SessionEntity?
  private var newRecord: QuestionRecordEntity?
  
  func create_step1_afterOnAppear(
    direction: IntervalPairCategory,
    clef: Clef,
    startTime: Date,
    startNote: Note,
    endNote: Note
  ) {
    guard !isForPreview else {
      return
    }
    
    // Step 1: 초기 엔티티 생성 및 필수 속성 설정
    createNewRecordEntity()
    
    guard let newRecord else {
      print("Error: newRecord is nil")
      return
    }
    
    newRecord.direction = direction.dataDescription
    newRecord.clef = clef.dataDescription
    newRecord.startTime = startTime
    newRecord.startNoteLetter = startNote.letter.description
    newRecord.startNoteOctave = Int16(startNote.octave)
    newRecord.endNoteLetter = endNote.letter.description
    newRecord.endNoteOctave = Int16(endNote.octave)
    
    currentSession?.addToQuestionRecords(newRecord)
    saveContext()
    
    print(newRecord, "step1 comp")
  }
  
  func create_step2_afterFirstTry(
    firstTryTime: Date,
    isCorrect: Bool,
    myInterval: AdvancedInterval
  ) {
    guard !isForPreview else {
      return
    }
    
    guard let newRecord else {
      print("Error: No active record to update for step 2")
      return
    }
    
    // Step 2: 첫 번째 시도 결과 설정
    newRecord.firstTryTime = firstTryTime
    newRecord.isCorrect = isCorrect
    newRecord.tryCount = 1
    newRecord.myIntervalModifier = myInterval.modifier.abbrDescription
    newRecord.myIntervalNumber = Int16(myInterval.number)
    
    // 정답일 경우 finalAnswerTime 설정
    if isCorrect {
      newRecord.finalAnswerTime = firstTryTime
    }
    
    saveContext()
    print(newRecord, "step2 comp")
  }
  
  func create_step3_whenWrongFirstTryAndFinallyAnswered(
    finalAnswerTime: Date,
    tryCount: Int16
  ) {
    guard !isForPreview else {
      return
    }
    
    guard let newRecord else {
      print("Error: No active record to update for step 3")
      return
    }
    
    // Step 3: 첫 시도에서 틀렸지만 정답에 도달한 경우 최종 정보 업데이트
    newRecord.finalAnswerTime = finalAnswerTime
    newRecord.tryCount = tryCount
    
    saveContext()
    print(newRecord, "step3 comp")
  }
  
  func createNewRecordEntity() {
    guard let context else {
      return
    }
    
    newRecord = QuestionRecordEntity(context: context)
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
}

extension QuestionRecordEntityCreateHelper {
  func read() -> String {
    if isForPreview {
      return "프리뷰 모드에서는 지원하지 않습니다."
    }
    
    guard let context else {
      return "Error: Context is not available in preview mode."
    }
    
    let sessionRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
    var csvString = "Session Name, Timestamp, Direction, Clef, Start Note, Start Octave, End Note, End Octave, First Try Time, Is Correct, Try Count, Final Answer Time, My Interval Modifier, My Interval Number\n"
    
    do {
      let sessions = try context.fetch(sessionRequest)
      
      for session in sessions {
        let sessionName = "Unnamed"
        let timestamp = session.createTime?.formatted() ?? "N/A"
        
        if let records = session.questionRecords as? Set<QuestionRecordEntity> {
          for record in records {
            let direction = record.direction ?? "N/A"
            let clef = record.clef ?? "N/A"
            let startNote = record.startNoteLetter ?? "N/A"
            let startOctave = record.startNoteOctave
            let endNote = record.endNoteLetter ?? "N/A"
            let endOctave = record.endNoteOctave
            let firstTryTime = record.firstTryTime?.formatted() ?? "N/A"
            let isCorrect = record.isCorrect ? "True" : "False"
            let tryCount = record.tryCount
            let finalAnswerTime = record.finalAnswerTime?.formatted() ?? "N/A"
            let myIntervalModifier = record.myIntervalModifier ?? "N/A"
            let myIntervalNumber = "\(record.myIntervalNumber)"
            
            csvString += "\(sessionName), \(timestamp), \(direction), \(clef), \(startNote), \(startOctave), \(endNote), \(endOctave), \(firstTryTime), \(isCorrect), \(tryCount), \(finalAnswerTime), \(myIntervalModifier), \(myIntervalNumber)\n"
          }
        } else {
          csvString += "\(sessionName), \(timestamp), No Records\n"
        }
      }
      
      return csvString
    } catch {
      return "Error: Failed to fetch data - \(error.localizedDescription)"
    }
  }
}
