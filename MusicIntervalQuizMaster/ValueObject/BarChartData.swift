//
//  BarChartData.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/2/24.
//

import Foundation

struct BarChartData: Identifiable {
  let id = UUID()
  let intervalModifier: String
  let correctCount: Int
  let totalCount: Int
  let accuracy: Double // 퍼센티지로 0.0 ~ 1.0
  let averageResponseTime: TimeInterval // 초 단위 평균 응답 시간
}
