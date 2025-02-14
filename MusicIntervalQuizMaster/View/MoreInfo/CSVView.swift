//
//  CSVView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 2/15/25.
//

import SwiftUI

struct CSVView: View {
  var csvText: String {
    QuizSessionManager(context: PersistenceController.shared.container.viewContext).fetchAllStatsAsCSV()
  }
  
  @State private var showCSVSheet: Bool = false
  
  var body: some View {
    ScrollView {
      Text(csvText)
        .padding(10)
        .font(.system(size: 7))
        // .textSelection(.enabled)
        // .onTapGesture {
        //   UIPasteboard.general.string = csvText
        // }
    }
    .navigationTitle("csv_view")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem {
        Button("export_csv") {
          showCSVSheet.toggle()
        }
      }
    }
    .sheet(isPresented: $showCSVSheet) {
      ShareTextView(text: csvText, fileName: "MusicIntervalQuizMaster_\(Date.now.timeIntervalSince1970)")
    }
  }
}

#Preview {
  CSVView()
}
