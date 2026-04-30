//
//  BookmarksView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 4/30/26.
//

import SwiftUI

// MARK: - View
struct BookmarksView: View {
  enum LayoutMode {
    case list
    case grid
  }
  
  @State private var layoutMode: LayoutMode = .list
  @State private var viewModel = BookmarkViewModel()
  
  @AppStorage(.cfgShowBookmarksAs) private var cfgShowBookmarksAs: Int = 0
  
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationView {
      Group {
        switch layoutMode {
        case .list:
          List(viewModel.displayItems) { item in
            RowView(item: item)
          }
          
        case .grid:
          ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
              ForEach(viewModel.displayItems) { item in
                GridCellView(item: item)
              }
            }
            .padding()
          }
        }
      }
      .navigationTitle("loc.bookmarks_title")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            withAnimation {
              layoutMode = layoutMode == .list ? .grid : .list
            }
          } label: {
            Image(systemName: layoutMode == .list ? "square.grid.2x2" : "list.bullet")
          }
        }
      }
      .onAppear {
        layoutMode = cfgShowBookmarksAs == 1 ? .grid : .list
        viewModel.fetchAllBookmarks()
      }
      .onChange(of: layoutMode) { _ in
        switch layoutMode {
        case .list:
          cfgShowBookmarksAs = 0
        case .grid:
          cfgShowBookmarksAs = 1
        }
      }
      .overlay {
        if viewModel.bookmarks.isEmpty {
          OverlayContentUnavailable
        }
      }
    }
  }
  
  @ViewBuilder private var OverlayContentUnavailable: some View {
    if #available(iOS 17.0, *) {
      ContentUnavailableView {
          Label("loc.bookmark.empty.title", systemImage: "tray.fill")
      } description: {
          Text("loc.bookmark.empty.description")
      }
    } else {
      VStack {
        Image(systemName: "tray.fill")
        Text("loc.bookmark.empty.title").font(.title2).bold()
        Text("loc.bookmark.empty.description")
          .foregroundStyle(.secondary)
      }
    }
  }
}

// MARK: - List Row
struct RowView: View {
  let item: BookmarkIntervalDisplayItem
  let squareMusiqiwkThumbSize: CGFloat = 60
  
  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color.gray.opacity(0.1))
        .frame(width: squareMusiqiwkThumbSize, height: squareMusiqiwkThumbSize)
        .clipped()
        .overlay {
          MiniMusiqwikView(pair: item.pair)
            .scaleEffect(0.9)
          // .offset(x: -0, y: 0)
        }
      VStack(alignment: .leading) {
        
        Text(verbatim: item.title)
          .font(.headline)
        Text(verbatim: item.subtitle)
          .font(.subheadline)
          .foregroundStyle(.gray)
      }
    }
    .padding(.vertical, 4)
  }
}

// MARK: - Grid Cell
struct GridCellView: View {
  let item: BookmarkIntervalDisplayItem
  
  var body: some View {
    VStack(spacing: 8) {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.gray.opacity(0.1))
        .frame(height: 100)
        .clipped()
        .overlay {
          MusiqwikView(pair: item.pair)
            .scaleEffect(0.9)
        }
      
      Text(verbatim: item.title)
        .font(.headline)
      
      Text(verbatim: item.subtitle)
        .font(.caption)
        .foregroundStyle(.gray)
        .lineLimit(2)
        .minimumScaleFactor(0.5)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.gray.opacity(0.2))
    )
  }
}

// MARK: - Preview
#Preview {
  BookmarksView()
}
