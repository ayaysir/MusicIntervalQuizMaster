//
//  IntervalInfoView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 3/20/25.
//

import SwiftUI
import Tonic

// TODO: - 하드코딩 없이 WebView등으로 분리, 내용 export 가능하게

struct IntervalInfoView: View {
  // MARK: - View main
  
  let pair: IntervalPair
  @State private var workItem: DispatchWorkItem?
  
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        if let interval = pair.advancedInterval {
          TitleArea(interval: interval)
          MusicSheetArea
          ContentArea(interval: interval)
          Spacer()
            .frame(height: 10)
          BottomButtonArea
        }
      }
      .padding(10)
    }
  }
}

extension IntervalInfoView {
  // MARK: - View segments
  
  private func TitleArea(interval: AdvancedInterval) -> some View {
    ZStack {
      Title(interval.localizedDescription)
      CloseButtonArea
    }
  }
  private func Title(_ text: String) -> Text {
    Text(verbatim: text)
      .font(.largeTitle)
      .bold()
  }
  
  private func Subtitle(_ text: String) -> Text {
    Text(verbatim: text)
      .font(.title2)
      .fontWeight(.semibold)
  }
  
  private func p(_ text: String) -> Text {
    Text(verbatim: text)
      .font(.body)
  }
  
  private func Footnote(_ text: String) -> Text {
    Text(verbatim: text)
      .font(.footnote)
  }
  
  private func StyledImage(_ image: Image) -> some View {
    image
      .resizable()
      .scaledToFit()
      // .frame(width: 300)
  }
  
  private var MusicSheetArea: some View {
    HStack(spacing: 50) {
      VStack {
        // 악보
        MusiqwikView(pair: pair)
          .frame(height: 100)
        Button {
          playSounds()
        } label: {
          Label(
            "",
            systemImage: "speaker.wave.3.fill"
          )
        }
      }
    }
  }
  
  private var BottomButtonArea: some View {
    Button {
      dismiss()
    } label: {
      Text("info_ok")
    }
    .buttonStyle(.borderedProminent)
  }
  
  private func ContentArea(interval: AdvancedInterval) -> some View {
    let octave = interval.number / 8
    let simpleIntervalNumber = interval.number - (7 * octave)
    let formula = "\(interval.number) - (7 × \(octave))"
    
    // default interval
    let defaultNote1 = Note(
      pair.startNote.letter,
      accidental: .natural,
      octave: pair.startNote.octave
    )
    let defaultNote2 = Note(
      pair.endNote.letter,
      accidental: .natural,
      octave: pair.endNote.octave
    )
    
    let defaultHalfStepCount = AdvancedInterval.halfsteps(defaultNote1, defaultNote2)
    
    // if 낮은 음이 변화한 경우
    let lowerNote = pair.startNote < pair.endNote ? pair.startNote : pair.endNote
    let higherNote = pair.startNote < pair.endNote ? pair.endNote : pair.startNote
    
    let isPerfectGroup = interval.modifier == .perfect
    
    let isSameAccidental = pair.startNote.accidental == pair.endNote.accidental
    
    let baseInterval = AdvancedInterval(
      modifier: interval.modifier,
      number: interval.number - (7 * octave)
    )
    
    let defaultIntervalPair = IntervalPair(
      startNote: lowerNote,
      endNote: higherNote,
      direction: .ascending,
      clef: pair.clef
    )
    
    return VStack(alignment: .leading) {
      if let defaultInterval = AdvancedInterval.betweenNotes(defaultNote1, defaultNote2) {
        Subtitle("info_title".localizedFormat(interval.localizedDescription))
        
        Divider()
        
        // MARK: - Section 1
        
        VStack(alignment: .leading) {
          p("info_1_1".localizedFormat(interval.number))
          Footnote("info_1_2".localized)
          // StyledImage(.init(.lineAndSpace))
          InfoSubLineAndSpaceView(defaultIntervalPair: defaultIntervalPair)
            .frame(
              width: UIScreen.main.bounds.width - 15,
              height: UIScreen.main.bounds.width * 0.44 - 15
            )
        }
        Spacer().frame(height: 20)
        
        // Additional: 복합 음정인 경우 설명 ✅
        if interval.number > 8 {
          p("info_1_3".localized)
          p(
            "info_1_4".localizedFormat(
              formula,
              simpleIntervalNumber,
              interval.localizedDescription,
              baseInterval.localizedDescription
            )
          )
        }
        
        Divider()
        
        // MARK: - Section 2
        
        p(
          "info_2_1".localizedFormat(
            interval.number,
            defaultHalfStepCount,
            defaultInterval.localizedDescription
          )
        )
        
        // 기본 음정 테이블 그리기
        
        let mode: DefaultIntervalTableView.Mode = interval.number > 8 ? .compound : .basic
        var highlightPosJ: Int? {
          if interval.number > 8 {
            return switch defaultHalfStepCount {
            case 2: 1
            case 3: 2
            case 4: 3
            default: nil
            }
          }
          
          return switch defaultHalfStepCount {
          case 0: 1
          case 1: 2
          case 2: 3
          default: nil
          }
        }
        var highlightPosI: Int? {
          return switch interval.number {
          case 1, 9, 10: 1
          case 2, 3, 11, 12: 2
          case 4, 5, 13: 3
          case 6, 7: 4
          case 8: 5
          default: nil
          }
        }
        let highlightPos: (Int, Int)? = if let highlightPosI, let highlightPosJ {
          (highlightPosI, highlightPosJ)
        } else {
          nil
        }
        
        DefaultIntervalTableView(mode: mode, highlight: highlightPos)
        
        Divider()
        
        // MARK: - Section 3
        
        StyledImage(.init(.intervalMovement))
        
        // if 양쪽 모두 높이 변화가 없는 경우
        if isSameAccidental {
          if lowerNote.accidental == .natural && higherNote.accidental == .natural {
            p("info_3_1".localized)
          } else {
            p("info_3_2".localized)
          }
          
        } else {
          // 낮은 노트+에서 높이 변화가 있는 경우
          if lowerNote.accidental != .natural {
            // 낮은 노트의 위치 변화
            let halfstepLow = getHalfStep(of: lowerNote.accidental, isLowerNoteChanged: true)
            let textPositionIs = getAccRaise(of: lowerNote.accidental)
            let textIntervalIs = getAccExpanded(of: lowerNote.accidental, isLowerNoteChanged: true)
            
            p(
              "info_3_3".localizedFormat(
                textPositionIs,
                abs(halfstepLow),
                textIntervalIs
              )
            )
            
            if let nextModifier = defaultInterval.modifier.move(isPerfectGroup: isPerfectGroup, count: halfstepLow) {
              
              p(
                "info_from_to".localizedFormat(
                  defaultInterval.modifier.localizedDescription,
                  nextModifier.localizedDescription
                )
              )
              
              if higherNote.accidental != .natural {
                Divider()
                
                let halfstepHigh = getHalfStep(of: higherNote.accidental)
                let textPositionIs = getAccRaise(of: higherNote.accidental)
                let textIntervalIs = getAccExpanded(of: higherNote.accidental)
                
                p(
                  "info_4_1".localizedFormat(
                    textPositionIs,
                    abs(halfstepHigh),
                    textIntervalIs
                  )
                )
                
                if let next2Modifier = nextModifier.move(isPerfectGroup: isPerfectGroup, count: halfstepHigh) {
                  p(
                    "info_from_to".localizedFormat(
                      nextModifier.localizedDescription,
                      next2Modifier.localizedDescription
                    )
                  )
                }
              }
            }
          } else if higherNote.accidental != .natural {
            // 낮은 노트는 변화가 없고, 높은 노트만 변화가 있는 경우
            let halfstepHigh = getHalfStep(of: higherNote.accidental)
            let textPositionIs = getAccRaise(of: higherNote.accidental)
            let textIntervalIs = getAccExpanded(of: higherNote.accidental)
            
            p(
              "info_3_4".localizedFormat(
                textPositionIs,
                abs(halfstepHigh),
                textIntervalIs
              )
            )
            if let nextModifier = defaultInterval.modifier.move(isPerfectGroup: isPerfectGroup, count: halfstepHigh) {
              p(
                "info_from_to".localizedFormat(
                  defaultInterval.modifier.localizedDescription,
                  nextModifier.localizedDescription
                )
              )
            }
          }
        }
        
        Divider()
        
        p(
          "info_therefore".localizedFormat(
            interval.localizedDescription
          )
        )
        
        Divider()
      } else {
        Text("Error")
      }
    }
  }
  
  private var CloseButtonArea: some View {
    HStack {
      Spacer()
      Button(action: dismiss.callAsFunction) {
        Image(systemName: "xmark")
          .font(.system(size: 10, weight: .bold)) // 아이콘 크기 조절
          .foregroundColor(.white) // 아이콘 색상
          .frame(width: 20, height: 20) // 버튼 크기 조절
          .background(Color.gray.opacity(0.6)) // 회색 배경
          .clipShape(Circle()) // 원형 버튼
      }
    }
  }
}

extension IntervalInfoView {
  // MARK: - Content related funcs
  
  private func getHalfStep(
    of accidental: Accidental,
    isLowerNoteChanged: Bool = false
  ) -> Int {
    let halfstep = switch accidental {
    case .natural:
      0
    case .sharp:
      1
    case .doubleSharp:
      2
    case .doubleFlat:
      -2
    case .flat:
      -1
    }
    
    return isLowerNoteChanged ? -halfstep : halfstep
  }
  
  private func getAccRaise(of accidental: Accidental) -> String {
    switch accidental {
    case .sharp, .doubleSharp:
      "info_raised".localized
    case .flat, .doubleFlat:
      "info_lowered".localized
    default:
      ""
    }
  }
  
  private func getAccExpanded(
    of accidental: Accidental,
    isLowerNoteChanged: Bool = false
  ) -> String {
    let expandedText = "info_expanded".localized
    let shrinkedText = "info_shrinked".localized
    
    return switch accidental {
    case .sharp, .doubleSharp:
      isLowerNoteChanged ? shrinkedText : expandedText
    case .flat, .doubleFlat:
      isLowerNoteChanged ? expandedText : shrinkedText
    default:
      ""
    }
  }
}

extension IntervalInfoView {
  // MARK: - Sound related funcs
  
  private func stopSounds() {
    SoundManager.shared.stopAllSounds()
    
    if let workItem {
      workItem.cancel()
    }
  }
  
  private func playSounds() {
    stopSounds()
    
    workItem = .init {
      pair.endNote.playSound()
    }
    
    let qos = DispatchQoS.QoSClass.userInitiated
    
    switch pair.direction {
    case .ascending, .descending:
      DispatchQueue.global(qos: qos).async {
        pair.startNote.playSound()
      }
      
      if let workItem {
        DispatchQueue.global(qos: qos).asyncAfter(
          deadline: .now() + .milliseconds(1200),
          execute: workItem
        )
      }
    case .simultaneously:
      DispatchQueue.global(qos: qos).async {
        pair.startNote.playSound()
        pair.endNote.playSound()
      }
    }
  }
}

#Preview {
  IntervalInfoView(
    pair: .init(
      startNote: .init(
        .C,
        accidental: .sharp,
        octave: 4
      ),
      endNote: .init(
        .E,
        accidental: .doubleFlat,
        octave: 5
      ),
      direction: .ascending,
      clef: .treble
    )
  )
}
