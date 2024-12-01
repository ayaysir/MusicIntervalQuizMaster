//
//  QuizSessionManager.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import Foundation
import CoreData
import Tonic

class QuizSessionManager {
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
  
  /// 세션만 생성하는 함수
  func createSession(uuid: UUID = .init(), createTime: Date = .now) -> SessionEntity? {
    let session = SessionEntity(context: context)
    session.id = uuid
    session.createTime = createTime

    do {
      try context.save()
      print("Session created with ID: \(session.id!)")
      
      return session
    } catch {
      print("Failed to create session: \(error.localizedDescription)")
      
      return nil
    }
  }
  
  /// Create QuestionRecordEntity and append to SessionEntity
  func addQuestionRecord(toSessionWithID sessionID: UUID, record: QuestionRecordEntity) -> Bool {
    let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", sessionID as CVarArg)
    
    do {
      if let session = try context.fetch(fetchRequest).first {
        session.addToQuestionRecords(record)
        try context.save()
        return true
      }
    } catch {
      print("Failed to add record: \(error.localizedDescription)")
    }
    
    return false
  }
  
  /// Create record(not entity) and append to SessionEntity
  func addQuestionRecord(toSessionWithID sessionID: UUID, record: QuestionRecord) -> Bool {
    let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", sessionID as CVarArg)
    
    do {
      // 세션 가져오기
      guard let session = try context.fetch(fetchRequest).first else {
        print("Error: Session with ID \(sessionID) not found.")
        return false
      }
      
      // QuestionRecordEntity 생성
      let recordEntity = QuestionRecordEntity(context: context)
      
      // QuestionRecord -> QuestionRecordEntity 매핑
      recordEntity.seq = Int16(record.seq)
      recordEntity.startTime = record.firstAppearedTime
      recordEntity.timerLimit = Int16(record.timerLimit)
      recordEntity.tryCount = Int16(record.tryCount)
      recordEntity.isCorrect = record.isCorrectAtFirstTry
      
      if let firstAttempt = record.attempts.first {
        recordEntity.firstTryTime = firstAttempt.time
        recordEntity.myIntervalModifier = firstAttempt.myInterval.modifier.abbrDescription
        recordEntity.myIntervalNumber = Int16(firstAttempt.myInterval.number)
      }
      
      recordEntity.finalAnswerTime = record.attempts.last?.time ?? .now
      
      // IntervalPair 매핑
      recordEntity.startNoteLetter = record.questionPair.startNote.letter.description
      recordEntity.startNoteAccidental = record.questionPair.startNote.accidental.description
      recordEntity.startNoteOctave = Int16(record.questionPair.startNote.octave)
      recordEntity.endNoteLetter = record.questionPair.endNote.letter.description
      recordEntity.endNoteAccidental = record.questionPair.endNote.accidental.description
      recordEntity.endNoteOctave = Int16(record.questionPair.endNote.octave)
      recordEntity.direction = record.questionPair.direction.dataDescription
      recordEntity.clef = record.questionPair.clef.dataDescription
      
      // 세션과 관계 설정
      recordEntity.session = session
      session.addToQuestionRecords(recordEntity)
      
      // 저장
      try context.save()
      
      return true
    } catch {
      print("Failed to add record: \(error.localizedDescription)")
      
      return false
    }
  }
  
  /// featch all stats as [Stat]
  func fetchAllStats() -> [Stat] {
    let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
    
    do {
      let sessions = try context.fetch(fetchRequest)
      var stats: [Stat] = []
      
      for session in sessions {
        guard
          let sessionId = session.id,
          let sessionCreateTime = session.createTime
        else {
          continue
        }
        
        if let records = session.questionRecords as? Set<QuestionRecordEntity> {
          for record in records {
            guard
              let startTime = record.startTime,
              let firstTryTime = record.firstTryTime,
              let finalAnswerTime = record.finalAnswerTime,
              let clef = record.clef,
              let direction = record.direction,
              let startNoteLetter = record.startNoteLetter,
              // let startNoteAccidental = record.startNoteAccidental,
              let endNoteLetter = record.endNoteLetter,
              // let endNoteAccidental = record.endNoteAccidental,
              let myIntervalModifier = record.myIntervalModifier
            else {
              continue
            }
            
            let stat = Stat(
              sessionId: sessionId,
              sessionCreateTime: sessionCreateTime,
              seq: Int(record.seq),
              startTime: startTime,
              timerLimit: Int(record.timerLimit),
              clef: clef,
              direction: direction,
              startNoteLetter: startNoteLetter,
              startNoteAccidental: record.startNoteAccidental ?? "",
              startNoteOctave: Int(record.startNoteOctave),
              endNoteLetter: endNoteLetter,
              endNoteAccidental: record.endNoteAccidental ?? "",
              endNoteOctave: Int(record.endNoteOctave),
              firstTryTime: firstTryTime,
              finalAnswerTime: finalAnswerTime,
              isCorrect: record.isCorrect,
              tryCount: Int(record.tryCount),
              myIntervalModifier: myIntervalModifier,
              myIntervalNumber: Int(record.myIntervalNumber)
            )
            stats.append(stat)
          }
        }
      }
      
      return stats
    } catch {
      print("Failed to fetch stats: \(error.localizedDescription)")
      
      return []
    }
  }
  
  func deleteAllSessions() {
    let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
    
    do {
      // 모든 세션 가져오기
      let sessions = try context.fetch(fetchRequest)
      
      // 세션 삭제
      for session in sessions {
        context.delete(session)
      }
      
      // 변경 사항 저장
      try context.save()
      
    } catch {
      // 오류 처리
      print("Error deleting all sessions: \(error.localizedDescription)")
    }
  }
  
  func fetchAllStatsAsCSV() -> String {
    let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
    
    do {
      let sessions = try context.fetch(fetchRequest)
      var csvRows: [String] = []
      
      // CSV 헤더 추가
      csvRows.append("""
        sessionId,sessionCreateTime,seq,startTime,timerLimit,clef,direction,startNoteLetter,startNoteAccidental,startNoteOctave,endNoteLetter,endNoteAccidental,endNoteOctave,firstTryTime,finalAnswerTime,isCorrect,tryCount,myIntervalModifier,myIntervalNumber
        """)
      
      for session in sessions {
        let sessionId = session.id?.uuidString ?? "N/A"
        let sessionCreateTime = session.createTime?.description ?? "N/A"
        
        if let records = session.questionRecords as? Set<QuestionRecordEntity> {
          for record in records {
            let seq = record.seq
            let startTime = record.startTime?.description ?? "N/A"
            let timerLimit = record.timerLimit
            let clef = record.clef ?? "N/A"
            let direction = record.direction ?? "N/A"
            
            let startNoteLetter = record.startNoteLetter ?? "N/A"
            let startNoteAccidental = record.startNoteAccidental ?? "N/A"
            let startNoteOctave = record.startNoteOctave
            
            let endNoteLetter = record.endNoteLetter ?? "N/A"
            let endNoteAccidental = record.endNoteAccidental ?? "N/A"
            let endNoteOctave = record.endNoteOctave
            
            let firstTryTime = record.firstTryTime?.description ?? "N/A"
            let finalAnswerTime = record.finalAnswerTime?.description ?? "N/A"
            let isCorrect = record.isCorrect
            let tryCount = record.tryCount
            
            let myIntervalModifier = record.myIntervalModifier ?? "N/A"
            let myIntervalNumber = record.myIntervalNumber
            
            let csvRow = """
              \(sessionId),\(sessionCreateTime),\(seq),\(startTime),\(timerLimit),\(clef),\(direction),\(startNoteLetter),\(startNoteAccidental),\(startNoteOctave),\(endNoteLetter),\(endNoteAccidental),\(endNoteOctave),\(firstTryTime),\(finalAnswerTime),\(isCorrect),\(tryCount),\(myIntervalModifier),\(myIntervalNumber)
              """
            csvRows.append(csvRow)
          }
        }
      }
      
      return csvRows.joined(separator: "\n")
    } catch {
      print("Failed to fetch stats: \(error.localizedDescription)")
      return ""
    }
  }
}
