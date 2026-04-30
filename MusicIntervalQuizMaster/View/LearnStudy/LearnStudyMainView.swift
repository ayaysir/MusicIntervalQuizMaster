//
//  LearnStudyMainView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 4/30/26.
//

import SwiftUI

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
        
        Section {
          NavigationLink {
            BookmarksView()
          } label: {
            Image(systemName: "bookmark.fill")
              .foregroundStyle(.secondary)
            Text("Bookmarks")
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
