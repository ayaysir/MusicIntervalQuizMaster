//
//  TutorialGuideView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct TutorialGuideView: View {
  @State private var currentIndex: Int = 0
  
  var body: some View {
    GeometryReader { proxy in
      VStack {
        Text(scripts[currentIndex].0)
          .font(.title)
          .frame(height: proxy.size.height * 0.15)
        ImageSlideView(images: TUTORIAL_IMAGES["country_prefix".localized] ?? [], currentIndex: $currentIndex)
          .frame(height: proxy.size.height * 0.65)
        Text(scripts[currentIndex].1)
          .font(.system(size: 14, weight: .medium))
          // .frame(height: proxy.size.height * 0.15)
      }
      .padding(10)
      .toolbar(.hidden, for: .tabBar) // 탭바 숨김
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

extension TutorialGuideView {
  var scripts: [(String, String)] {
    [
      ("script_1_title".localized,
       "script_1_body".localized),
      
      ("script_2_title".localized,
       "script_2_body".localized),
      
      ("script_3_title".localized,
       "script_3_body".localized),
      
      ("script_4_title".localized,
       "script_4_body".localized),
      
      ("script_5_title".localized,
       "script_5_body".localized),
      
      ("script_6_title".localized,
       "script_6_body".localized),
      
      ("script_7_title".localized,
       "script_7_body".localized)
    ]
  }
}

#Preview {
  TutorialGuideView()
}

/*
 1페이지: 홈 화면, 퀴즈 스크린샷: 음정을 마스터할 수 있게 하는 앱
 2페이지: 퀴즈 스크린샷: 화면 소개 (4개)
 3페이지: 퀴즈 따라해보기
 4페이지: 통계 스크린샷: 화면 소개
 5페이지: 설정 스크린샷: 화면 소개 (2개)
 
 
 악보를 보고 하단의 음정 키보드를 눌러 음정을 입력하세요. 디스플레이에 현재 입력된 음정이 표시됩니다.
 
 키보드는 직관적인 구조로 되어 있습니다. 왼쪽 영역은 음정의 성질(quality) 부분이고, 오른쪽 부분은 음정의 도수(degree)입니다. 예를 들어 완전 5도를 입력하려면 [완전음정] + [5] 버튼을 누르면 됩니다.
 
 음정을 입력하고 엔터 버튼을 누르면 채점이 되어 정답 여부를 알 수 있습니다.
 
 악보를 터치하면 해당 악보가 재생됩니다. 오른쪽 상단 [🔊 AUTO] 버튼을 누르면 문제가 출제될 때마다 자동 재생이 됩니다.
 
 현재 세션의 상황 및 타이머 표시를 상단에서 볼 수 있습니다.
 
 타이머 기능이 제공되어 제한 시간 안에 문제를 푸는 것이 가능합니다. 시간 안에 풀지 못하면 틀린 것으로 처리됩니다. 악보가 표시되는 수직 위치를 조정하는 버튼도 있습니다.
 
 앱을 끄지 않는 한, 무수히 많은 음정문제가 출제되어 퀴즈를 풀다보면 어느 새 음정 계산의 도사가 되어 있을 것입니다.
 
 정답을 알아내야 다음 문제로 이동할 수 있습니다. 틀렸더라도 다시 분석해서 정답에 도전해보세요!
 
 통계 탭에서 나의 취약점 및 강점을 분석하고 학습 계획을 수립하세요.
 
 필터가 제공되어 원하는 카테고리의 음정에 대한 결과만 볼 수도 있습니다. 그래프를 좌우로 슬라이드하면 세부 카테고리에 대한 정답률 또는 소요시간이 표시됩니다. 예를 들어 낮은음자리표의 결과만 보고 싶다면 그래프를 이동하면 낮은음자리표 문제만의 정답률 또는 소요 시간이 표시됩니다.
 
 문제풀이 조건을 간단 또는 자세하게 지정하세요.
 
 겹증/겹감 및 9도 이상의 복합음정을 문제에 포함시키거나 임시표, 음자리표, 음표의 배치에 따른 세밀한 조건 설정이 가능합니다.
 
 앱 설정으로 앱을 더 편리하게 이용해보세요.
 
 타이머, 자동넘김, 햅틱, 앱 테마를 설정할 수 있습니다. 앱을 내 취향에 맞춰 더 몰입감 있는 학습이 가능하게 됩니다.
 
 --------
 

 
 
 */
