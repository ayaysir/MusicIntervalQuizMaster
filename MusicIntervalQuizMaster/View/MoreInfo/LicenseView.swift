//
//  LicenseView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 11/28/24.
//

import SwiftUI

struct LicenseView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("MusiQwik")
          .font(.title2).bold()
        Text("Copyright (c) 2001, 2008 by Robert Allgeyer. SIL Open Font License.")
        Divider()
        Text("Tonic")
          .font(.title2).bold()
        Text("MIT license")
        Link("https://www.audiokit.io/Tonic", destination: URL(string: "https://www.audiokit.io/Tonic/")! )
        Divider()
        Text("AlertKit")
          .font(.title2).bold()
        Text("MIT license")
        Link("https://github.com/sparrowcode/AlertKit", destination: URL(string: "https://github.com/sparrowcode/AlertKit")! )
        Divider()
        Spacer()
      }
      .padding(.horizontal, 20)
    }
    .navigationTitle("오픈 소스 저작권 보기")
  }
}
  
#Preview {
  LicenseView()
}
