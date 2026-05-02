//
//  LearnStudyMainView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 4/30/26.
//

import SwiftUI

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

// MARK: - Main
struct LearnStudyMainView: View {
  var body: some View {
    NavigationStack {
      List {
        VStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .frame(width: 100, height: 100)
            .foregroundStyle(.alertIcon)
            .overlay(
              Image(systemName: "graduationcap")
                .font(.system(size: 50))
                .foregroundStyle(.bwBackground.opacity(0.9))
            )
            
          Text(verbatim: "Learn & Study")
            .font(.title)
            .bold()
          Text("loc.learn_description")
            .font(.callout)
            .foregroundStyle(.secondary)
            // .background(.red)
          
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
#if LITE_VERSION
        Section {
          let adSize = largeAnchoredAdaptiveBanner(width: 345)
          BannerViewContainer(adSize)
            .frame(width: adSize.size.width, height: adSize.size.height)
        }
#endif
        
        Section {
          NavigationLink {
            BookmarksView()
          } label: {
            Image(systemName: "bookmark.fill")
              .foregroundStyle(.secondary)
              .frame(width: 20)
            Text("loc.bookmarks_title")
          }
        }
        

        
        Section {
          NavigationLink {
            IntervalCalculatorView()
          } label: {
            Image(systemName: "square.grid.3x3.bottomright.filled")
              .frame(width: 20)
              .symbolRenderingMode(.palette)
              .foregroundStyle(.green, .secondary, .green)
            Text("loc.calc.title")
          }
        }
      }
      .navigationTitle("Learn & Study")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

// MARK: - View elements (fragments)
extension LearnStudyMainView {
  
}

// MARK: - View elements (Group)
extension LearnStudyMainView {
  
}

// MARK: - Init/View related methods/vars
extension LearnStudyMainView {
  
}

// MARK: - Utility methods
extension LearnStudyMainView {
  
}

// MARK: - #Preview
#Preview {
  LearnStudyMainView()
}
