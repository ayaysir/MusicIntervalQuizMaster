//
//  QuizSession.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/29/24.
//

import Foundation

struct QuizSession {
  let uuid: UUID
  let createTime: Date
  
  var records: [QuestionRecord] = []
}

extension QuizSession {
  var recordsCount: Int {
    records.count
  }
  
  func record(at index: Int) -> QuestionRecord {
    records[index]
  }
}
