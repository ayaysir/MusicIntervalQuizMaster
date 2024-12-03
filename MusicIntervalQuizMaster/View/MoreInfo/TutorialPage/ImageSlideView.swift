//
//  ImageSlideView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/4/24.
//

import SwiftUI

struct ImageSlideView: View {
  let images: [UIImage] // 이미지 이름 배열
  @Binding var currentIndex: Int
  
  var body: some View {
    GeometryReader { geometry in
      let imageWidth = geometry.size.width * 0.7 // 현재 이미지 너비
      let spacing = geometry.size.width * 0.1 // 이미지 간 간격
      let totalWidth = imageWidth + spacing
      
      VStack {
        // Spacer()
        HStack(spacing: spacing) {
          ForEach(images.indices, id: \.self) { index in
            Image(uiImage: images[index])
              .resizable()
              .scaledToFill()
              .frame(width: imageWidth, height: geometry.size.height * 0.8)
              .cornerRadius(15)
              .shadow(radius: 5)
          }
        }
        .frame(height: geometry.size.height)
        .padding(.horizontal, (geometry.size.width - imageWidth) / 2)
        .offset(x: -CGFloat(currentIndex) * totalWidth)
        .animation(.easeInOut, value: currentIndex)
        .gesture(
          DragGesture()
            .onEnded { value in
              let threshold = totalWidth / 20
              if value.translation.width < -threshold {
                currentIndex = min(currentIndex + 1, images.count - 1)
              } else if value.translation.width > threshold {
                currentIndex = max(currentIndex - 1, 0)
              }
            }
        )
        
        // Spacer()
      }
    }
  }
  

}

#Preview {
  ImageSlideView(images: TUTORIAL_IMAGES["ko"] ?? [], currentIndex: .constant(0))
    // .frame(height: proxy.size.height * 0.7)
    .background(Color.gray.opacity(0.2))
}
