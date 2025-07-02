//
//  SimpleTableView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 7/2/25.
//

import SwiftUI

struct DefaultIntervalTableView: View {
  enum Mode {
    case basic, compound
  }
  
  @Environment(\.colorScheme) private var colorScheme
  var mode: Mode = .basic
  var highlight: (i: Int, j: Int)? = nil
  
  private func cellBackground(i: Int, j: Int) -> Color? {
    guard let highlight else {
      return nil
    }
    
    let colorCondition = (i, j) == (0, highlight.j)
    || (i, j) == (highlight.i, 0)
    || (i, j) == highlight
    
    let color: Color = if colorCondition {
      .pink
    } else {
      .bwBackground
    }
    
    let opacity: CGFloat = if (i, j) == highlight {
      colorScheme == .dark ? 0.6 : 0.4
    } else if (i, j) == (0, highlight.j)
                || (i, j) == (highlight.i, 0) {
      colorScheme == .dark ? 0.3 : 0.1
    } else {
      1
    }
    
    return color
      .opacity(opacity)
  }
  
  var body: some View {
    let rows = mode == .compound ? compoundTable : basicTable
    Grid(horizontalSpacing: 0) {
      GridRow {
        ForEach(rows[0].indices, id: \.self) { j in
          Text(rows[0][j])
            .frame(maxWidth: .infinity)
            .background(cellBackground(i: 0, j: j))
            .bold()
        }
      }

      Divider()
      
      ForEach(1...(rows.count - 1), id: \.self) { i in
        GridRow {
          ForEach(rows[i].indices, id: \.self) { j in
            if j == 0 || (highlight?.i == i && highlight?.j == j) {
              Text(rows[i][j])
                .frame(maxWidth: .infinity)
                .background(cellBackground(i: i, j: j))
                .bold()
            } else {
              Text(rows[i][j])
                .frame(maxWidth: .infinity)
                .background(cellBackground(i: i, j: j))
            }
          }
        }
      }
    }
    .padding()
    .onAppear {
      // let intervals: [AdvancedInterval] = [
      //   .init(modifier: .perfect, number: 1),
      //   .init(modifier: .minor, number: 2),
      //   .init(modifier: .major, number: 2),
      //   .init(modifier: .minor, number: 3),
      //   .init(modifier: .major, number: 3),
      //   .init(modifier: .perfect, number: 4),
      //   .init(modifier: .augmented, number: 4),
      //   .init(modifier: .diminished, number: 5),
      //   .init(modifier: .perfect, number: 5),
      //   .init(modifier: .minor, number: 6),
      //   .init(modifier: .major, number: 6),
      //   .init(modifier: .minor, number: 7),
      //   .init(modifier: .major, number: 7),
      //   .init(modifier: .perfect, number: 8),
      //   .init(modifier: .minor, number: 9),
      //   .init(modifier: .major, number: 9),
      //   .init(modifier: .minor, number: 10),
      //   .init(modifier: .major, number: 10),
      //   .init(modifier: .perfect, number: 11),
      //   .init(modifier: .augmented, number: 11),
      //   .init(modifier: .diminished, number: 12),
      //   .init(modifier: .perfect, number: 12),
      //   .init(modifier: .minor, number: 13),
      //   .init(modifier: .major, number: 13),
      // ]
      // intervals.forEach { print($0.semitone) }
    }
  }
  
  let basicTable = {
    let P = IntervalModifier.perfect.shortLocalizedDescription
    let M = IntervalModifier.major.shortLocalizedDescription
    let m = IntervalModifier.minor.shortLocalizedDescription
    let A = IntervalModifier.augmented.shortLocalizedDescription
    let d = IntervalModifier.diminished.shortLocalizedDescription
    
    return [
      ["loc.degree_semitone".localized, "0", "1", "2"],
      ["1", P, "", ""],
      ["2/3", M, m, ""],
      ["4/5", A, P, d],
      ["6/7", "", M, m],
      ["8", "", "", P],
    ]
  }()
  
  let compoundTable = {
    let P = IntervalModifier.perfect.shortLocalizedDescription
    let M = IntervalModifier.major.shortLocalizedDescription
    let m = IntervalModifier.minor.shortLocalizedDescription
    let A = IntervalModifier.augmented.shortLocalizedDescription
    let d = IntervalModifier.diminished.shortLocalizedDescription
    return [
      ["loc.degree_semitone".localized, "2", "3", "4"],
      ["9/10", M, m, ""],
      ["11/12", A, P, d],
      ["13", "", M, m],
    ]
  }()
}

#Preview {
  VStack {
    DefaultIntervalTableView(mode: .basic)
    DefaultIntervalTableView(mode: .compound)
  }
}
