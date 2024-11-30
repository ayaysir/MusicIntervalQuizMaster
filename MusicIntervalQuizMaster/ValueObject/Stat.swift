//
//  Stat.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import Foundation

struct Stat {
  let sessionId: UUID
  let sessionCreateTime: Date
  
  // 세션 내에서 Record의 순서
  let seq: Int
  
  // 시작시간
  let startTime: Date
  let timerLimit: Int

  // 음정문제
  let clef: String
  let direction: String
  
  let startNoteLetter: String
  let startNoteAccidental: String
  let startNoteOctave: Int
  
  let endNoteLetter: String
  let endNoteAccidental: String
  let endNoteOctave: Int
  
  // 문제풀이 상황
  let firstTryTime: Date
  let finalAnswerTime: Date
  let isCorrect: Bool
  let tryCount: Int
  
  let myIntervalModifier: String
  let myIntervalNumber: Int
}

extension Stat {
  var oneLineDescription: String {
    """
    \(sessionId.uuidString)\t\(sessionCreateTime)\t\(seq)\t\(startTime)\t\(timerLimit)\t\
    \(clef)\t\(direction)\t\(startNoteLetter)\t\(startNoteAccidental)\t\(startNoteOctave)\t\
    \(endNoteLetter)\t\(endNoteAccidental)\t\(endNoteOctave)\t\(firstTryTime)\t\
    \(finalAnswerTime)\t\(isCorrect)\t\(tryCount)\t\(myIntervalModifier)\t\(myIntervalNumber)
    """
  }
}
