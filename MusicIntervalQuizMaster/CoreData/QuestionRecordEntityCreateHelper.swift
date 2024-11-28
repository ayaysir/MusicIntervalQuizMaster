//
//  QuestionRecordEntityCreateHelper.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/29/24.
//

import Foundation
import CoreData

// class QuestionRecordEntityCreateHelper: ObservableObject {
//   private let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
//   private let isForPreview: Bool
//   
//   init(isForPreview: Bool = false) {
//     self.isForPreview = isForPreview
//   }
//   
//   // MARK: - 3-step entry
//   private var newRecord: QuestionRecordEntity?
//   
//   func create_step1_afterOnAppear(
//     direction: String,
//     clef: String,
//     startTime: Date,
//     startNoteLetterAbbr: String,
//     startNoteNumber: Int16,
//     endNoteLetterAbbr: String,
//     endNoteNumber: Int16
//   ) {
//     guard !isForPreview else {
//       return
//     }
//     
//     // Step 1: 초기 엔티티 생성 및 필수 속성 설정
//     newRecord = QuestionRecordEntity(context: context)
//     
//     guard let newRecord else {
//       print("Error: newRecord is nil")
//       return
//     }
//     
//     newRecord.direction = direction
//     newRecord.startTime = startTime
//     newRecord.startNoteLetterAbbr = startNoteLetterAbbr
//     newRecord.startNoteNumber = startNoteNumber
//     newRecord.myNoteLetterAbbr = endNoteLetterAbbr
//     newRecord.myNoteNumber = endNoteNumber
//     
//     saveContext()
//   }
//   
//   func create_step2_afterFirstTry(
//     firstTryTime: Date,
//     isCorrect: Bool,
//     myNoteLetterAbbr: String,
//     myNoteNumber: Int16
//   ) {
//     guard !isForPreview else {
//       return
//     }
//     
//     guard let newRecord else {
//       print("Error: No active record to update for step 2")
//       return
//     }
//     
//     // Step 2: 첫 번째 시도 결과 설정
//     newRecord.firstTryTime = firstTryTime
//     newRecord.isCorrect = isCorrect
//     newRecord.tryCount = 1
//     newRecord.myNoteLetterAbbr = myNoteLetterAbbr
//     newRecord.myNoteNumber = myNoteNumber
//     
//     // 정답일 경우 finalAnswerTime 설정
//     if isCorrect {
//       newRecord.finalAnswerTime = firstTryTime
//     }
//     
//     saveContext()
//   }
//   
//   func create_step3_whenWrongFirstTryAndFinallyAnswered(
//     finalAnswerTime: Date,
//     tryCount: Int16
//   ) {
//     guard !isForPreview else {
//       return
//     }
//     
//     guard let newRecord else {
//       print("Error: No active record to update for step 3")
//       return
//     }
//     
//     // Step 3: 첫 시도에서 틀렸지만 정답에 도달한 경우 최종 정보 업데이트
//     newRecord.finalAnswerTime = finalAnswerTime
//     newRecord.tryCount = tryCount
//     
//     saveContext()
//     
//     self.newRecord = nil
//   }
//   
//   // MARK: - Save
//   private func saveContext() {
//     if context.hasChanges {
//       do {
//         try context.save()
//       } catch {
//         print("Failed to save context: \(error.localizedDescription)")
//       }
//     }
//   }
// }
