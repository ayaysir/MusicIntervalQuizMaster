//
//  AppStoreScreenshotsView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/4/24.
//

import SwiftUI

struct AppStoreScreenshotsView: View {
  @State private var currentIndex = 0
  
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Color(white: 0.96)
          .ignoresSafeArea()
        VStack {
          Text("appstore_screenshots_\(currentIndex + 1)".localized)
            .multilineTextAlignment(.center)
            .padding(10)
            .font(.largeTitle)
            .fontWeight(.semibold)
          GeometryReader { proxy in
            let imageWidth = proxy.size.width * 0.7 // 현재 이미지 너비
            
            TabView(selection: $currentIndex) {
              ForEach(0..<5, id: \.self) { index in
                ZStack {
                  if let image = images["country_prefix".localized]?[index] {
                    image
                      .resizable()
                      .scaledToFill()
                      .frame(width: imageWidth, height: proxy.size.height * 0.95)
                      .clipShape(RoundedRectangle(cornerRadius: 10))
                      .shadow(radius: 5)
                      .padding(10)
                      .tag(0)
                  }
                }
              }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .tabItem { EmptyView() }
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
          .background(Color(white: 0.96))
          .frame(height: proxy.size.height * 0.75)
        }
      }
      
      .edgesIgnoringSafeArea(.top)  // 상단을 무시하고 전체 화면을 차지하도록 설정
    }
  }
}

extension AppStoreScreenshotsView {
  var images: [String : [Image]] {
    [
      "ja": [
        .init(.ja2QuizCorrectView),
        .init(.ja1QuizCorrectAlert),
        .init(.ja3QuizWrongAlert),
        .init(.ja5Stats),
        .init(.ja6Setting1),
      ]
      ,
      "ko": [
        .init(.ko2QuizCorrectView),
        .init(.ko1QuizCorrectAlert),
        .init(.ko3QuizWrongAlert),
        .init(.ko5Stats),
        .init(.ko6Setting1),
      ],
      "en": [
        .init(.en2QuizCorrectView),
        .init(.en1QuizCorrectAlert),
        .init(.en3QuizWrongAlert),
        .init(.en5Stats),
        .init(.en6Setting1),
      ],
    ]
  }
}

#Preview {
  AppStoreScreenshotsView()
}

/*
 1. 앱 소개 : 
 "어려운 음정 공부 🤯😵‍💫😭\n악보와 소리가 들리는 퀴즈로 쉽게 풀어요 👍👍"
 
 2. 정답 화면 : 
 "전용 키보드로 편리하게 🎹\n정답을 입력하고 채점 ✅"
 
 3. 틀린 화면 : 
 "틀린 문제는 맞출때까지! 💪💪\n수많은 문제로 누구나 음정 마스터 🎯"
 
 4. 통계 화면 : 
 "통계 기능을 이용해📊\n계획적인 학습 가능 🎓"
 
 5. 설정 화면 (앞) : 
 "문제 범위를 정하고 📚\n방식도 내 마음대로 설정 ⚙️"
 */
