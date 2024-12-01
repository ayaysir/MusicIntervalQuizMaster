//
//  ContentViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/15/24.
//

import Foundation
import Tonic

final class QuizViewModel: ObservableObject {
  private(set) var pairs: [IntervalPair] = []
  
  @Published var session = QuizSession(uuid: .init(), createTime: .now)
  @Published private(set) var currentPairIndex = 0
  @Published var answerMode: QuizAnswerMode = .inQuiz
  
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
  
  /// 신규 Pair 준비
  /// - 신규 pairs들 중 푼 문제들이 Session.records에 들어가므로 여기서 세션 초기화
  func preparePairData() {
    pairs = []
    currentPairIndex = 0
    
    let availableIntervalList = availableIntervalList()
    
    print(availableIntervalList)
    
    while pairs.count <= MAX_QUESTION_COUNT {
      if let pair = generateRandomIntervalPair(),
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
      "✅ 맞았습니다. \(currentPair.advancedInterval?.localizedDescription ?? "") [\(currentPair.startNote) - \(currentPair.endNote)]"
    case .wrong:
      "❌ 틀렸습니다. 다시 한 번 풀어보세요."
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
      print(cdAppendResult ? "CD에 record append 성공: \(currentRecord)" : "CD에 record append 실패")
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
  
  private func generateRandomIntervalPair() -> IntervalPair? {
    guard let category = determinedCategory,
          let clef = determinedClef,
          let accidental1 = determinedAccidental,
          let accidental2 = determinedAccidental
    else {
      print("category, clef, accidental는 반드시 만들어져야 하는데:", 
            determinedCategory as Any,
            determinedClef as Any,
            determinedAccidental as Any,
            store.bool(forKey: .checkInitConfigCompleted)
      )
      
      print(store.bool(forKey: .cfgNotesAscending), 
            store.bool(forKey: .cfgNotesDescending),
            store.bool(forKey: .cfgNotesSimultaneously)
      )
      return nil
    }
    
    let startLetter = Letter(rawValue: .random(in: 0...6))
    let endLetter = Letter(rawValue: .random(in: 0...6))
    
    guard let startLetter, let endLetter else {
      return nil
    }
    
    let startOctave = clef.randomAvailableOctave(startLetter)
    let endOctave = clef.randomAvailableOctave(endLetter)
    
    let notes: [Note] = [
      .init(startLetter, accidental: accidental1, octave: startOctave),
      .init(endLetter, accidental: accidental2, octave: endOctave),
    ].sorted {
      if $0.relativeNotePosition != $1.relativeNotePosition {
        $0.relativeNotePosition < $1.relativeNotePosition
      } else {
        $0.accidental.rawValue < $1.accidental.rawValue
      }
    }
    
    let pair = IntervalPair(
      startNote: category != .descending ? notes[0] : notes[1],
      endNote: category != .descending ? notes[1] : notes[0],
      direction: category,
      clef: clef
    )
    
    return pair
  }
  
  var determinedCategory: IntervalPairDirection? {
    [
      store.bool(forKey: .cfgNotesAscending) ? IntervalPairDirection.ascending : nil,
      store.bool(forKey: .cfgNotesDescending) ? IntervalPairDirection.descending : nil,
      store.bool(forKey: .cfgNotesSimultaneously) ? IntervalPairDirection.simultaneously : nil,
    ].compactMap { $0 }.randomElement()
  }
  
  var determinedClef: Clef? {
    [
      store.bool(forKey: .cfgClefTreble) ? Clef.treble : nil,
      store.bool(forKey: .cfgClefBass) ? Clef.bass : nil,
      store.bool(forKey: .cfgClefAlto) ? Clef.alto : nil,
    ].compactMap { $0 }.randomElement()
  }
  
  var determinedAccidental: Accidental? {
    [
      Accidental.natural, Accidental.natural, Accidental.natural, 
      store.bool(forKey: .cfgAccidentalSharp) ? Accidental.sharp : nil,
      store.bool(forKey: .cfgAccidentalFlat) ? Accidental.flat : nil,
      store.bool(forKey: .cfgAccidentalDoubleSharp) ? Accidental.doubleSharp : nil,
      store.bool(forKey: .cfgAccidentalDoubleFlat) ? Accidental.doubleFlat : nil,
    ].compactMap { $0 }.randomElement()
  }
  
  func availableIntervalList() -> [AdvancedInterval] {
    var list: [AdvancedInterval] = []
    
    do {
      let boolStates = try store.getObject(forKey: .cfgIntervalTypeStates, castTo: StringBoolDict.self)
      
      boolStates.forEach {
        let splitted = $0.key.split(separator: "_")
        
        guard let number = Int(splitted[1]),
              let modifier = IntervalModifier.from(abbreviation: String(splitted[0])) else {
          return
        }
        
        let isIncludeCompound = store.bool(forKey: .cfgIntervalFilterCompound)
        let isIncludeDoublyTritone = store.bool(forKey: .cfgIntervalFilterDoublyTritone)
        
        /*
         꺼져 있을 때
         [P1, m2, M2, d2, m3, M3, d3, P4, A4, d4, m5, M5, A5, d5, P6, A6, d6, m7, M7, d7, P8, A8, d8]

         둘 다 켜져 있을 때
         [P1, m2, M2, d2, m3, M3, d3, P4, A4, AA4, d4, dd4, m5, M5, A5, AA5, d5, dd5, P6, A6, d6, m7, M7, d7, P8, A8, d8, m12, M12, P13]

         차이점
         [AA4, AA5, dd4, dd5, m12, M12, P13]
         */
        guard $0.value,
              (isIncludeCompound || number <= 8), // isIncludeCompound가 false면 number <= 8 이어야 함
              (isIncludeDoublyTritone || (modifier != .doublyAugmented && modifier != .doublyDiminished)) // isIncludeDoublyTritone가 false면 특정 modifier 포함 금지
        else {
          return
        }
        
        list.append(.init(modifier: modifier, number: number))
      }
    } catch {
      print(error)
    }
    
    if list.isEmpty {
      return [AdvancedInterval(modifier: .perfect, number: 5)]
    }
    
    return list
  }
}

import SwiftUI
#Preview {
  QuizView()
}
