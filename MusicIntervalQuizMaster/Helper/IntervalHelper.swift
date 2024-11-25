//
//  IntervalHelper.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/26/24.
//

import Foundation
import Tonic

struct IntervalHelper {
  static var shared = IntervalHelper()
  
  /*
   C - C : 완전 1도
   C - C# : 증 1도
   C - Db : 단 2도
   C - D :  장 2도
   C - D# : 증 2도
   C - Eb : 단 3도
   C - E : 장 3도
   C - F : 완전 4도
   C - F# : 증 4도
   C - Gb : 감 5도
   C - G : 완전 5도
   C - G# : 증 5도
   C - Ab : 단 6도
   C - A : 장 6도
   C - A# : 증 6도
   C - Bb : 단 7도
   C - B: 장 7도
   
   1) x도 만큼 음을 올린다. (반음 포함여부 무관)
   예) 3도: C -> E, E - G, G -> B
   
   2) 장음정
   2-1) 장 3도 이하이고, 두 음 사이에 반음이 없다면, prefix는 그대로 따라간다.
   예) C# -> E#, Gb -> Bb, G -> B
   
   2-2) 장 3도 이하이고, 두 음 사이에 반음이 한 개 있다면 (3-4 또는 7-8), 원래 음에서 반음이 높아진다(=prefix가 1단계 높아진다).
   예) E -> G는 E -> G#, Eb -> G는 Eb -> G(=), C -> A
   
   2-3) 장 6 ~ 7도이고, 두 음 사이에 반음이 한 개 있다면 prefix는 그대로 따라간다.
   예) C -> A, Db -> Bb, G# -> E#
   
   2-4) 장 6 ~ 7도이고, 두 음 사이에 반음이 두 개 있다면, 원래 음에서 반음이 높아진다(=prefix가 1단계 높아진다).
   예) E -> C# (EF, BC), A -> F# (BC, EF), Bb -> G (BC, EF)
   
   3) 단음정
   장음정을 기준으로 먼저 계산한 뒤, 반음 내린다(=prefix는 1단계 낮아진다).
   예1) C -> Eb (단 3도, from E), Eb -> Gb (단 3도, from G), Gb -> Bbb (from Bb), F# -> A (단 3도, from A#)
   예2) E -> C (from C#), Db -> Bbb (from Bb), Bb -> Ab (from A)
   
   4) 완전음정
   4-1) 완전음정 4, 5도 사이에 반음이 한 개 있다면, prefix는 그대로 따라간다.
   예) C -> F (EF), Eb -> Ab (EF), Bb -> Eb (BC)
   
   4-2) 완전음정 4, 5도 사이에 반음이 한 개 있다면, 반음씩 올리면 된다(=prefix가 1단계 높아진다).
   예) Bb -> F (BC, EF)
   
   4-3) 완전음정 4, 5도 사이에 반음이 하나도 없다면, 원래 음에서 반음이 낮아진다(=prefix는 1단계 낮아진다).
   참고) 이 케이스는 F밖에 존재할 수밖에 없다.
   예) F -> Bb, F# -> B, Fb -> Fbb
   
   5) 증음정
   장음정 또는 완전음정을 기준으로 먼저 계산한 뒤, 반음씩 올리면 된다(=prefix가 1단계 높아진다).
   예) C -> C# (증 1도, from C), E -> F## (증 2도, from F#)
   
   6) 감음정
   감 5도만 있음 (겹증, 겹감, 감 4도(=장 3도) 제외)
   완전 5도에서 반음 내린다(=prefix는 1단계 낮아진다).
   예) Eb -> Bbb (from Bb), F# -> C (from C#)
   
   */
}

