//
//  Untitled.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 4/30/26.
//

import Foundation
import Tonic

struct BookmarkIntervalDisplayItem: Identifiable {
  /// 제목 예) 증 2도 [C3 - D#3]
  var title: String
  /// 부제목 예) 낮은음자리표, 상향, 등록일
  var subtitle: String
  /// 악보 표시용 음정 짝
  var pair: IntervalPair
  
  var id: String {
    title
  }
}


final class BookmarkViewModel: ObservableObject {
  private var bookmarkManager = BookmarkManager(context: PersistenceController.shared.container.viewContext)
  @Published private(set) var bookmarks: [BookmarkIntervalEntity] = []
  
  init() {
    fetchAllBookmarks()
  }
  
  func fetchAllBookmarks() {
    bookmarks = bookmarkManager.readAll()
  }
  
  var displayItems: [BookmarkIntervalDisplayItem] {
    bookmarks.compactMap { entity -> BookmarkIntervalDisplayItem? in
      guard let startNoteAccidental = entity.startNoteAccidental,
            let startNoteLetter = entity.startNoteLetter,
            let endNoteAccidental = entity.endNoteAccidental,
            let endNoteLetter = entity.endNoteLetter,
            let directionString = entity.direction,
            let clefString = entity.clef else {
        return nil
      }
      
      let startNoteOctave = Int(entity.startNoteOctave)
      let endNoteOctave = Int(entity.endNoteOctave)
      
      guard let startNote = Note.from(letterString: startNoteLetter, accidentalString: startNoteAccidental, octave: startNoteOctave),
            let endNote = Note.from(letterString: endNoteLetter, accidentalString: endNoteAccidental, octave: endNoteOctave),
            let direction = IntervalPairDirection(dataDescription: directionString),
            let clef = Clef(dataDescription: clefString)
      else {
        return nil
      }
      
      let pair = IntervalPair(
        startNote: startNote,
        endNote: endNote,
        direction: direction,
        clef: clef
      )
      
      let dateText = entity.createdAt?.formatted(date: .long, time: .shortened) ?? "-"
      
      return BookmarkIntervalDisplayItem(
        title: "\(pair.advancedInterval?.localizedDescription, default: "-") [\(startNote.description) - \(endNote.description)]",
        subtitle: "\(direction.localizedDescription), \(clef.shortLocalizedDescription)\n\(dateText)",
        pair: pair
      )
    }
  }
  
  // func makeSpecificTextOfSomeElement() {
  //   // 어떻게? 예를 들어
  //   // bookmarks 의 3번 원소의 값들을 조합해서 내보내고 싶다고 할 떄
  // }
}
