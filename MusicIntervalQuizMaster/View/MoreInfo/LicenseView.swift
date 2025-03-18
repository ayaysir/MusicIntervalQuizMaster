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
        licenseInfoCell(
          title: "MusiQwik",
          licenseText: "Copyright (c) 2001, 2008 by Robert Allgeyer. SIL Open Font License."
        )
        
        licenseInfoCell(
          title: "Tonic",
          licenseText: "MIT license",
          urlString: "https://www.audiokit.io/Tonic"
        )
        
        licenseInfoCell(
          title: "AlertKit",
          licenseText: "MIT license",
          urlString: "https://github.com/sparrowcode/AlertKit"
        )

        licenseInfoCell(
          title: "Starling",
          licenseText: "MIT license",
          urlString: "https://github.com/matthewreagan/Starling"
        )
        
        Spacer()
      }
      .padding(.horizontal, 20)
    }
    .navigationTitle("open_source_licenses")
  }
  
  private func licenseInfoCell(
    title: String,
    licenseText: String,
    urlString: String? = nil
  ) -> some View {
    Group {
      VStack(alignment: .leading) {
        Text(title)
          .font(.title2).bold()
        Text(licenseText)
        if let urlString {
          Link(urlString, destination: URL(string: urlString)! )
        }
      }
      
      Divider()
    }
  }
}
  
#Preview {
  LicenseView()
}
