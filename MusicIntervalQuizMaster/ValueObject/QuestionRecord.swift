//
//  QuestionRecord.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/29/24.
//

import Foundation

struct QuestionRecord {
  let sessionId: UUID
  let seq: Int
  let questionPair: IntervalPair
  let firstAppearedTime: Date
  var attempts: [QuizAttempt] = []
  
  var isCorrectAtFirstTry: Bool = false
  var isCompleted: Bool = false
}

extension QuestionRecord {
  var tryCount: Int {
    attempts.count
  }
}
