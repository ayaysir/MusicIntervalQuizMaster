//
//  IntervalHelperTests.swift
//  MusicIntervalQuizMasterTests
//
//  Created by 윤범태 on 11/26/24.
//

import XCTest
import Tonic
@testable import MusicIntervalQuizMaster

final class IntervalHelperTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() {
    let C4 = Note(.C, accidental: .natural, octave: 4)
    
    print(AdvancedInterval.betweenNotes(C4, .init(.F, accidental: .natural, octave: 4)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.G, accidental: .natural, octave: 4)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.D, accidental: .natural, octave: 4)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.E, accidental: .natural, octave: 4)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.A, accidental: .natural, octave: 4)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.B, accidental: .natural, octave: 4)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.C, accidental: .natural, octave: 4)) as Any)
    
    print(AdvancedInterval.betweenNotes(C4, .init(.C, accidental: .natural, octave: 5)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.D, accidental: .natural, octave: 5)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.E, accidental: .natural, octave: 5)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.F, accidental: .natural, octave: 5)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.G, accidental: .natural, octave: 5)) as Any)
    print(AdvancedInterval.betweenNotes(C4, .init(.A, accidental: .natural, octave: 5)) as Any)
    
    print(AdvancedInterval.betweenNotes(.init(.A, accidental: .sharp, octave: 4), .init(.B, accidental: .flat, octave: 4)) as Any)
  }
  
  func testBetweenNotes_basicIntervals() {
    
    let noteC4 = Note(.C, accidental: .natural, octave: 4)
    let noteG4 = Note(.G, accidental: .natural, octave: 4)
    let noteE4 = Note(.E, accidental: .natural, octave: 4)
    
    XCTAssertEqual(
      AdvancedInterval.betweenNotes(noteC4, noteG4),
      AdvancedInterval(modifier: .perfect, number: 5),
      "C4 to G4 should be a perfect fifth"
    )
    
    XCTAssertEqual(
      AdvancedInterval.betweenNotes(noteC4, noteE4),
      AdvancedInterval(modifier: .major, number: 3),
      "C4 to E4 should be a major third"
    )
  }
  
  func testBetweenNotes_withAccidentals() {
    let noteC4 = Note(.C, accidental: .sharp, octave: 4)
    let noteD4 = Note(.D, accidental: .flat, octave: 4)
    
    // 임시표 없을 때 M2 -> m -> d
    XCTAssertEqual(
      AdvancedInterval.betweenNotes(noteC4, noteD4),
      AdvancedInterval(modifier: .diminished, number: 2),
      "C#4 to Db4 should be a diminished second"
    )
    
    let noteF4 = Note(.F, accidental: .natural, octave: 4)
    let noteA4 = Note(.A, accidental: .flat, octave: 4)
    
    XCTAssertEqual(
      AdvancedInterval.betweenNotes(noteF4, noteA4),
      AdvancedInterval(modifier: .minor, number: 3),
      "F4 to Ab4 should be a minor third"
    )
  }
  
  func testBetweenNotes_crossingOctaves() {
    let noteC4 = Note(.C, accidental: .natural, octave: 4)
    let noteC5 = Note(.C, accidental: .natural, octave: 5)
    
    XCTAssertEqual(
      AdvancedInterval.betweenNotes(noteC4, noteC5),
      AdvancedInterval(modifier: .perfect, number: 8),
      "C4 to C5 should be a perfect octave"
    )
    
    let noteD4 = Note(.D, accidental: .flat, octave: 4)
    let noteG5 = Note(.G, accidental: .sharp, octave: 5)
    
    XCTAssertEqual(
      AdvancedInterval.betweenNotes(noteD4, noteG5),
      AdvancedInterval(modifier: .doublyAugmented, number: 11),
      "Db4 to G#5 should be an doubly augmented 11"
    )
  }
  
  func testBetweenNotes_invalidIntervals() {
    let noteC4 = Note(.C, accidental: .doubleFlat, octave: 4)
    let noteC3 = Note(.C, accidental: .doubleSharp, octave: 3)
    
    XCTAssertNil(
      AdvancedInterval.betweenNotes(noteC4, noteC3),
      "Cbb4 to C##3 should be invalid since the interval is not determined(nil)"
    )
  }
}
