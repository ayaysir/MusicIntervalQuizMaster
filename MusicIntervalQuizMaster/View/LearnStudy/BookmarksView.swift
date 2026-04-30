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
  @StateObject private var viewModel = BookmarkViewModel()
  @State private var selectedPair: IntervalPair?
  @State private var removeTargetPair: IntervalPair?
  @State private var showDeleteAlert = false

  @AppStorage(.cfgShowBookmarksAs) private var cfgShowBookmarksAs: Int = 0
  @State private var workItem: DispatchWorkItem?
  
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationView {
      Group {
        switch layoutMode {
        case .list:
          AreaList
        case .grid:
          AreaGridScrollView
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
      .sheet(item: $selectedPair) { item in
        IntervalInfoView(pair: item)
      }
      .alert("btn_del", isPresented: $showDeleteAlert) {
        Button(role: .cancel) { } label: {
          Text("loc.cancel")
        }
        Button(role: .destructive) {
          if let pair = removeTargetPair {
            viewModel.removeBookmark(pair: pair)
          }
        } label: {
          Text("btn_del")
        }
      } message: {
        Text("loc.cancel.message")
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

extension BookmarksView {
  @ViewBuilder private var AreaList: some View {
    List(viewModel.displayItems) { item in
      RowView(item: item) {
        playSounds(pair: item.pair)
      }
      .onTapGesture {
        selectedPair = item.pair
      }
      .swipeActions {
        Button(role: .destructive) {
          viewModel.removeBookmark(pair: item.pair)
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
    }
    // .refreshable {
    //   viewModel.fetchAllBookmarks()
    // }
  }
  
  @ViewBuilder private var AreaGridScrollView: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(viewModel.displayItems) { item in
          GridCellView(item: item) {
            playSounds(pair: item.pair)
          }
          .onTapGesture {
            selectedPair = item.pair
          }
          .onLongPressGesture {
            removeTargetPair = item.pair
            showDeleteAlert.toggle()
          }
        }
      }
    }
    // .refreshable {
    //   viewModel.fetchAllBookmarks()
    // }
    .padding()
  }
}

extension BookmarksView {
  // MARK: - Sound related funcs
  
  private func stopSounds() {
    SoundManager.shared.stopAllSounds()
    
    if let workItem {
      workItem.cancel()
    }
  }
  
  private func playSounds(pair: IntervalPair?) {
    stopSounds()
    
    guard let pair else {
      return
    }
    
    workItem = .init {
      pair.endNote.playSound()
    }
    
    let qos = DispatchQoS.QoSClass.userInitiated
    
    switch pair.direction {
    case .ascending, .descending:
      DispatchQueue.global(qos: qos).async {
        pair.startNote.playSound()
      }
      
      if let workItem {
        DispatchQueue.global(qos: qos).asyncAfter(
          deadline: .now() + .milliseconds(800),
          execute: workItem
        )
      }
    case .simultaneously:
      DispatchQueue.global(qos: qos).async {
        pair.startNote.playSound()
        pair.endNote.playSound()
      }
    }
  }
}

// MARK: - List Row
struct RowView: View {
  let item: BookmarkIntervalDisplayItem
  let squareMusiqiwkThumbSize: CGFloat = 60
  var soundHandler: (() -> Void)? = nil
  
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
      Spacer()
      Button(action: {
        soundHandler?()
      }) {
        Image(systemName: "speaker.wave.2.fill")
          .symbolRenderingMode(.hierarchical)
          .tint(.soundOnTint)
      }
      .buttonStyle(.borderless)
      .controlSize(.mini)
      .symbolRenderingMode(.hierarchical)
    }
    .padding(.vertical, 4)
  }
}

// MARK: - Grid Cell
struct GridCellView: View {
  let item: BookmarkIntervalDisplayItem
  var soundHandler: (() -> Void)? = nil
  
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
        
      HStack {
        Text(verbatim: item.subtitle)
          .font(.caption)
          .foregroundStyle(.gray)
          .lineLimit(2)
          .minimumScaleFactor(0.5)
        Button(action: {
          soundHandler?()
        }) {
          Image(systemName: "speaker.wave.2.fill")
            .symbolRenderingMode(.hierarchical)
            .tint(.soundOnTint)
            .font(.system(size: 14))
        }
        .buttonStyle(.borderless)
        .controlSize(.mini)
        .symbolRenderingMode(.hierarchical)
      }
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
