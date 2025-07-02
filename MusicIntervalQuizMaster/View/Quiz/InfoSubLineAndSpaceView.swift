//
//  InfoSubLineAndSpaceView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 7/1/25.
//

import SwiftUI
import Tonic

struct InfoSubLineAndSpaceView: View {
  let baseWidth: CGFloat = 100
  let defaultIntervalPair: IntervalPair
  
  var body: some View {
    GeometryReader {
      let positions = positions()
      
      DrawCanvas(minCanvasPos: positions.minPos, maxCanvasPos: positions.maxPos)
        .frame(width: $0.size.width, height: $0.size.width * 0.45)
    }
  }
}

extension InfoSubLineAndSpaceView {
  func positions() -> (minPos: Int, maxPos: Int) {
    /*
     RelativePosition
     treble: 26 ~ 40 (A3 ~ A5)
     bass: 14 ~ 28 (C2 ~ C4)
     alto: 20 ~ 34 (B2 ~ B4)
     
     canvasPos  treble  bass  alto
     1  40  28  34
     2  39  27  33
     3  38  26  32
     4  37  25  31
     5  36  24  30
     6  35  23  29
     7  34  22  28
     8  33  21  27
     9  32  20  26
     10 31  19  25
     11 30  18  24
     12 29  17  23
     13 28  16  22
     14 27  15  21
     15 26  14  20
     */
    let pair = defaultIntervalPair
    
    let p1 = canvasPos(for: defaultIntervalPair.startNote.relativeNotePosition, clef: pair.clef)
    let p2 = canvasPos(for: defaultIntervalPair.endNote.relativeNotePosition, clef: pair.clef)
    
    return (min(p1, p2), max(p1, p2))
  }
  
  func canvasPos(for relativePosition: Int, clef: Clef) -> Int {
    switch clef {
    case .treble: return 41 - relativePosition
    case .bass:   return 29 - relativePosition
    case .alto:   return 35 - relativePosition
    }
  }
  
  func drawLabelOutline(
    _ context: inout GraphicsContext,
    _ size: CGSize,
    textView label: Text,
    origin: CGPoint,
    strokeColor: Color,
    lineWidth: CGFloat
  ) {
    let resolved = context.resolve(label)
    let outlineSize = resolved.measure(in: size)
    let origin = CGPoint(
      x: origin.x - outlineSize.width / 2,
      y: origin.y - outlineSize.height / 2
    )
    let rect = CGRect(origin: origin, size: outlineSize)
    
    context.stroke(Path(rect), with: .color(strokeColor), lineWidth: lineWidth)
  }
  
  func drawLine(
    _ context: inout GraphicsContext,
    _ size: CGSize,
    start: CGPoint,
    end: CGPoint,
    strokeColor: Color,
    lineWidth: CGFloat
  ) {
    var path = Path()
    path.move(to: start)
    path.addLine(to: end)
    context.stroke(path, with: .color(strokeColor), lineWidth: lineWidth)
  }
  
  @ViewBuilder private func DrawCanvas(minCanvasPos: Int, maxCanvasPos: Int) -> some View {
    Canvas { (context, size) in
      let normalizer = NormalizeValue(
        originalValue: size.width,
        normalizationBase: baseWidth
      )
      let N = normalizer.applyNormalized(to:)
      // let midX = size.width / 2
      
      let totalNormalizedHeight = N(45)
      let midY = N(20)
      
      // context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.mint))
      
      let subLineWidth = N(0.27)
      let blackLinePadding = N(25)
      let subLinePadding = N(13.6)
      let fontSize = N(3.43)
      let betweenLines = N(5)
      let hiddenLineWidth = N(0.08)
      let sheetLineWidth = N(0.7)
      let numberLabelBackgroundWidth = N(5)
      let noteWidth = N(4.2)
      let noteHeight = N(4)
      
      // 텍스트 추가 (선 끝에)
      let linesLabel = Text("lines")
        .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
        .foregroundColor(.primary)
      let spacesLabel = Text("spaces")
        .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
        .foregroundColor(.primary)
      
      let linesLabelOriginX = subLinePadding / 2
      let spacesLabelOriginX = size.width - (subLinePadding / 2)
      context.draw(linesLabel, at: CGPoint(x: linesLabelOriginX, y: midY))
      context.draw(spacesLabel, at: CGPoint(x: spacesLabelOriginX, y: midY))
      
      // 텍스트 윤곽선 추가
      drawLabelOutline(
        &context,
        size,
        textView: linesLabel,
        origin: .init(x: linesLabelOriginX, y: midY),
        strokeColor: .red,
        lineWidth: subLineWidth
      )
      
      drawLabelOutline(
        &context,
        size,
        textView: spacesLabel,
        origin: .init(x: spacesLabelOriginX, y: midY),
        strokeColor: .teal,
        lineWidth: subLineWidth
      )
      
      // 오선
      
      // 영역 외 (회색)
      for y in [betweenLines, betweenLines * 7, betweenLines * 8] {
        drawLine(
          &context,
          size,
          start: .init(x: blackLinePadding, y: y),
          end: .init(x: size.width - blackLinePadding, y: y),
          strokeColor: .bwGray.opacity(0.7),
          lineWidth: hiddenLineWidth
        )
      }
      
      // 영역 내 오선
      for i in 1...5 {
        let y = N(5) + N(5) * CGFloat(i)
        
        drawLine(
          &context,
          size,
          start: .init(x: blackLinePadding, y: y),
          end: .init(x: size.width - blackLinePadding, y: y),
          strokeColor: .frontLabel,
          lineWidth: sheetLineWidth
        )
        
        drawLine(
          &context,
          size,
          start: .init(x: subLinePadding, y: midY),
          end: .init(x: blackLinePadding, y: y),
          strokeColor: .red,
          lineWidth: subLineWidth
        )
        
        if i != 1 {
          drawLine(
            &context,
            size,
            start: .init(x: size.width - subLinePadding, y: midY),
            end: .init(x: size.width - blackLinePadding - N(1.5), y: y - betweenLines / 2),
            strokeColor: .teal,
            lineWidth: subLineWidth
          )
        }
        
       
      }
      
      // 숫자 라벨 배경
      let rect = CGRect(
        x: N(60) - (numberLabelBackgroundWidth / 2),
        y: 0,
        width: numberLabelBackgroundWidth,
        height: totalNormalizedHeight
      )
      let path = Path(rect)
      
      // 반투명 흰색 (블러 느낌)
      context.fill(path, with: .color(Color.bwBackground.opacity(0.8)))
      
      // 외곽선
      context.stroke(path, with: .color(.bwBackground.opacity(0.5)), lineWidth: 1)
      
      // 숫자 라벨
      var labelNum = 1 + maxCanvasPos - minCanvasPos
      for i in 1...15 where (minCanvasPos...maxCanvasPos) ~= i {
        // let x = (lowerCanvasPos...higherCanvasPos) ~= i
        
        let text = Text(labelNum.description)
          .font(.system(size: N(2.4), design: .monospaced))
          .foregroundColor(.primary)
        labelNum -= 1
        let labelY = (betweenLines / 2) + (betweenLines / 2) * CGFloat(i)
        context.draw(text, at: CGPoint(x: N(60), y: labelY))
      }
      
      // 음표
      for i in 1...15 where i == minCanvasPos || i == maxCanvasPos {
        let noteY = N(0.5) + (betweenLines / 2) * CGFloat(i)
        // 온음표 머리 (타원)
        var headPath = Path()
        let noteRect = CGRect(
          x: N(50),
          y: noteY,
          width: noteWidth,
          height: noteHeight
        )
        headPath.addEllipse(in: noteRect)
        
        context.stroke(headPath, with: .color(.frontLabel), lineWidth: 1.5)
        // 1또는 7일 경우 검은색 가운데 줄 그리기
      }
    }
  }
}

#Preview {
  let defaultNote1: Note = .init(.B, accidental: .sharp, octave: 2)
  let defaultNote2: Note = .init(.C, accidental: .natural, octave: 4)
  let defaultPair = IntervalPair(
    startNote: defaultNote1,
    endNote: defaultNote2,
    direction: .ascending,
    clef: .alto
  )
  
  InfoSubLineAndSpaceView(defaultIntervalPair: defaultPair)
    .frame(width: 300)
  
}
