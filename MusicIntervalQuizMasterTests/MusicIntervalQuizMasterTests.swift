//
//  MusicIntervalQuizMasterTests.swift
//  MusicIntervalQuizMasterTests
//
//  Created by 윤범태 on 11/21/24.
//

import XCTest
import Tonic
@testable import MusicIntervalQuizMaster

final class MusicIntervalQuizMasterTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    
    /* Tonic의 구조
     C𝄫3  C𝄫  C  58  𝄫  46  [💥]
     C♭3  C♭  C  59  ♭  47  [💥]
     C3  C  C  48    48
     C♯3  C♯  C  49  ♯  49
     C𝄪3  C𝄪  C  50  𝄪  50
     D𝄫3  D𝄫  D  48  𝄫  48
     D♭3  D♭  D  49  ♭  49
     D3  D  D  50    50
     D♯3  D♯  D  51  ♯  51
     D𝄪3  D𝄪  D  52  𝄪  52
     E𝄫3  E𝄫  E  50  𝄫  50
     E♭3  E♭  E  51  ♭  51
     E3  E  E  52    52
     E♯3  E♯  E  53  ♯  53
     E𝄪3  E𝄪  E  54  𝄪  54
     F𝄫3  F𝄫  F  51  𝄫  51
     F♭3  F♭  F  52  ♭  52
     F3  F  F  53    53
     F♯3  F♯  F  54  ♯  54
     F𝄪3  F𝄪  F  55  𝄪  55
     G𝄫3  G𝄫  G  53  𝄫  53
     G♭3  G♭  G  54  ♭  54
     G3  G  G  55    55
     G♯3  G♯  G  56  ♯  56
     G𝄪3  G𝄪  G  57  𝄪  57
     A𝄫3  A𝄫  A  55  𝄫  55
     A♭3  A♭  A  56  ♭  56
     A3  A  A  57    57
     A♯3  A♯  A  58  ♯  58
     A𝄪3  A𝄪  A  59  𝄪  59
     B𝄫3  B𝄫  B  57  𝄫  57
     B♭3  B♭  B  58  ♭  58
     B3  B  B  59    59
     B♯3  B♯  B  48  ♯  60  [💥]
     B𝄪3  B𝄪  B  49  𝄪  61  [💥]
     
     C𝄫4  C𝄫  C  70  𝄫  58  [💥]
     C♭4  C♭  C  71  ♭  59  [💥]
     C4  C  C  60    60
     C♯4  C♯  C  61  ♯  61
     C𝄪4  C𝄪  C  62  𝄪  62
     D𝄫4  D𝄫  D  60  𝄫  60
     D♭4  D♭  D  61  ♭  61
     D4  D  D  62    62
     D♯4  D♯  D  63  ♯  63
     D𝄪4  D𝄪  D  64  𝄪  64
     E𝄫4  E𝄫  E  62  𝄫  62
     E♭4  E♭  E  63  ♭  63
     E4  E  E  64    64
     E♯4  E♯  E  65  ♯  65
     E𝄪4  E𝄪  E  66  𝄪  66
     F𝄫4  F𝄫  F  63  𝄫  63
     F♭4  F♭  F  64  ♭  64
     F4  F  F  65    65
     F♯4  F♯  F  66  ♯  66
     F𝄪4  F𝄪  F  67  𝄪  67
     G𝄫4  G𝄫  G  65  𝄫  65
     G♭4  G♭  G  66  ♭  66
     G4  G  G  67    67
     G♯4  G♯  G  68  ♯  68
     G𝄪4  G𝄪  G  69  𝄪  69
     A𝄫4  A𝄫  A  67  𝄫  67
     A♭4  A♭  A  68  ♭  68
     A4  A  A  69    69
     A♯4  A♯  A  70  ♯  70
     A𝄪4  A𝄪  A  71  𝄪  71
     B𝄫4  B𝄫  B  69  𝄫  69
     B♭4  B♭  B  70  ♭  70
     B4  B  B  71    71
     B♯4  B♯  B  60  ♯  72  [💥]
     B𝄪4  B𝄪  B  61  𝄪  73  [💥]
     */
  
    var notes: [Note] = []
    
    for i in [3, 4] {
      for j in 0...6 {
        for k in -2...2 {
          notes.append(Note(.init(rawValue: j)!, accidental: .init(rawValue: Int8(k))!, octave: i))
        }
      }
    }
    
    notes.forEach { note in
      let orthodoxPitch = 12 + note.letter.basePitch + Int(note.accidental.rawValue) + note.octave * 12
      print(
        note,
        note.noteClass,
        note.letter,
        note.noteNumber,
        note.accidental,
        orthodoxPitch,
        note.noteNumber != orthodoxPitch ? "[💥]" : "",
        separator: "\t"
      )
    }
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
}
