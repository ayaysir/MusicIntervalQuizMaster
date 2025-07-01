//
//  InfoSubLineAndSpaceView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 7/1/25.
//

import SwiftUI

struct InfoSubLineAndSpaceView: View {
  let baseWidth: CGFloat = 100
  
  var body: some View {
    GeometryReader {
      DrawCanvas
        .frame(width: $0.size.width, height: $0.size.width * 0.4)
        // .aspectRatio(0.4, contentMode: .fit)
    }
    // .aspectRatio(0.4, contentMode: .fit)
  }
}

extension InfoSubLineAndSpaceView {
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
  
  private var DrawCanvas: some View {
    Canvas { (context, size) in
      let normalizer = NormalizeValue(
        originalValue: size.width,
        normalizationBase: baseWidth
      )
      let N = normalizer.applyNormalized(to:)
      // let midX = size.width / 2
      let midY = N(20)
      let totalNormalizedHeight = N(40)
      
      context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.mint))
      
      let subLineWidth = N(0.24)
      let blackLinePadding = N(25)
      let subLinePadding = N(13.6)
      let fontSize = N(3.43)
      let betweenLines = N(5)
      let hiddenLineWidth = N(0.05)
      let sheetLineWidth = N(0.7)
      let numberLabelBackgroundWidth = N(5)
      
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
      drawLine(
        &context,
        size,
        start: .init(x: blackLinePadding, y: betweenLines),
        end: .init(x: size.width - blackLinePadding, y: betweenLines),
        strokeColor: .gray.opacity(0.5),
        lineWidth: hiddenLineWidth
      )
      drawLine(
        &context,
        size,
        start: .init(x: blackLinePadding, y: betweenLines * 7),
        end: .init(x: size.width - blackLinePadding, y: betweenLines * 7),
        strokeColor: .gray.opacity(0.5),
        lineWidth: hiddenLineWidth
      )
      
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
        
        drawLine(
          &context,
          size,
          start: .init(x: size.width - subLinePadding, y: midY),
          end: .init(x: size.width - blackLinePadding, y: y),
          strokeColor: .teal,
          lineWidth: subLineWidth
        )
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
      context.fill(path, with: .color(Color.white.opacity(0.8)))
      
      // 외곽선
      context.stroke(path, with: .color(.white.opacity(0.5)), lineWidth: 1)
      
      // 숫자 라벨
      for i in 1...14 {
        let text = Text("\(i)")
          .font(.system(size: N(2.4), design: .monospaced))
        let y = (betweenLines / 2) * CGFloat(i)
        context.draw(text, at: CGPoint(x: N(60), y: y))
      }
      
      // 음표(?)
      for i in 1...7 {
        let y = N(CGFloat(5 * i)) - N(2)
        // 온음표 머리 (타원)
        var headPath = Path()
        let noteRect = CGRect(
          x: N(50),
          y: y,
          width: N(5),
          height: N(4)
        )
        headPath.addEllipse(in: noteRect)
        
        context.stroke(headPath, with: .color(.black), lineWidth: 1.5)
        // 1또는 7일 경우 검은색 가운데 줄 그리기
      }
    }
  }
}

#Preview {
  InfoSubLineAndSpaceView()
}
