//
//  ContentViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/15/24.
//

import Foundation
import Tonic
import SwiftUI

final class QuizViewModel: ObservableObject {
  private(set) var pairs: [IntervalPair] = []
  
  @Published var session = QuizSession(uuid: .init(), createTime: .now)
  @Published private(set) var currentPairIndex = 0
  @Published var answerMode: QuizAnswerMode = .inQuiz
  @Published var sessionCreated = 0
  
  @AppStorage(.cfgSkipAutoQuizStart) var cfgSkipAutoQuizStart = false
  
  private var manager = QuizSessionManager(context: PersistenceController.shared.container.viewContext)
  
  init(cdManager: QuizSessionManager? = nil) {
    if !store.bool(forKey: .checkInitConfigCompleted) {
      MusicIntervalQuizMasterApp.initConfigValues()
    }
    
    if let cdManager {
      self.manager = cdManager
    }
    
    preparePairData()
  }
  
  /// 신규 Pair 준비: 새로운 세션
  /// - 신규 pairs들 중 푼 문제들이 Session.records에 들어가므로 여기서 세션 초기화
  func preparePairData() {
    pairs = []
    currentPairIndex = 0
    
    let availableIntervalList = QuizHelper.shared.availableIntervalList()
    
    // print(availableIntervalList)
    
    while pairs.count <= MAX_QUESTION_COUNT {
      if let pair = QuizHelper.shared.generateRandomIntervalPair(),
         let interval = pair.advancedInterval,
         availableIntervalList.contains(interval) {
        pairs.append(pair)
      }
    }
  
    let uuid = UUID()
    let createTime = Date.now
    
    // 세션 생성 및 CD에 등록, uuid는 session 내부에 저장되어있음
    session = QuizSession(uuid: uuid, createTime: createTime)
    _ = manager.createSession(uuid: uuid, createTime: createTime)
    print("created session ID:", uuid, createTime)
    
    // 첫 번째 Record 생성
    createRecordsFromPairIndex()
    
    answerMode = .inQuiz
    sessionCreated += 1
  }
  
  func createRecordsFromPairIndex() {
    let record: QuestionRecord = .init(sessionId: session.uuid, seq: currentPairIndex, questionPair: pairs[currentPairIndex], firstAppearedTime: .now, timerLimit: store.integer(forKey: .cfgTimerSeconds))
    session.records.append(record)
  }
  
  var answerCount: Int {
    session.records.filter { $0.isCorrectAtFirstTry }.count
  }
  
  var wrongCount: Int {
    session.records.filter { $0.attempts.count > 0 && !$0.isCorrectAtFirstTry }.count
  }
  
  var answerPercentText: String {
    let totalCount = answerMode == .inQuiz ? max(session.records.count - 1, 0) : session.records.count
    
    guard totalCount > 0 else {
      return "0%"
    }
    // Thread 1: Fatal error: Double value cannot be converted to Int because it is either infinite or NaN
    return "\(Int(Double(answerCount) / Double(totalCount) * 100))%"
  }
  
  var currentPairIsNotSolved: Bool {
    session.recordsCount <= currentPairIndex
  }
  
  var isCurrentPairCountEqualLastMax: Bool {
    currentPairIndex == session.records.endIndex
  }
  
  var answerText: String {
    switch answerMode {
    case .inQuiz:
      ""
    case .correct:
      // 이모지 제거
      "\("correct_message".localized) \(currentPair.advancedInterval?.localizedDescription ?? "") [\(currentPair.startNote) - \(currentPair.endNote)]"
    case .wrong:
      "incorrect_message_try_again".localized
    }
  }
  
  func checkAnswer(_ modifier: IntervalModifier, _ number: Int) -> Bool {
    guard let interval = currentPair.advancedInterval else {
      print(#function, "Interval is nil")
      return false
    }
    
    let myInterval = AdvancedInterval(modifier: modifier, number: number)
    let isCorrect = myInterval == interval
    let attempt = QuizAttempt(time: .now, myInterval: myInterval, isCorrect: isCorrect)
    
    // attempt 넣기
    if let last = session.records.last {
      // 마지막 인덱스랑 현재 인덱스가 동일한 경우
      // 틀렸다면 attempts에 요소를 넣을 것이고
      // 맞았다면 바로 다음문제로 넘어가도록 되어있으니 넣을 일이 없다.
      if currentPairIndex == last.seq {
        session.records[currentPairIndex].attempts.append(attempt)
      }
    } else if session.records[currentPairIndex].attempts.isEmpty {
      session.records[currentPairIndex].attempts.append(attempt)
    }
    
    if isCorrect {
      let currentRecord = session.records[currentPairIndex]
      session.records[currentPairIndex].isCorrectAtFirstTry = currentRecord.tryCount == 1
      
      let cdAppendResult = manager.addQuestionRecord(toSessionWithID: session.uuid, record: session.records[currentPairIndex])
      print(cdAppendResult ? "CD에 record append 성공: \(currentRecord.seq)" : "CD에 record append 실패")
    }
    
    answerMode = isCorrect ? .correct : .wrong
    
    return isCorrect
  }
  
  var isNextQuestionAlreadyAppeared: Bool {
    print(currentPairIndex, session.records.endIndex)
    return currentPairIndex + 1 < session.records.endIndex
  }
  
  var currentPair: IntervalPair {
    pairs[currentPairIndex]
  }
  
  var currentRecord: QuestionRecord {
    session.records[currentPairIndex]
  }
  
  func next() {
    guard currentPairIndex <= pairs.count - 1 else {
      return
    }
    
    answerMode = .inQuiz
    currentPairIndex += 1
    
    if currentPairIndex > (session.recordsCount - 1) {
      // Set to complete
      session.records[currentPairIndex - 1].isCompleted = true
      createRecordsFromPairIndex()
    }
  }
  
  func prev() {
    guard currentPairIndex > 0 else {
      return
    }
    
    answerMode = .inQuiz
    currentPairIndex -= 1
  }
}

// import SwiftUI
// #Preview {
//   QuizView()
// }
