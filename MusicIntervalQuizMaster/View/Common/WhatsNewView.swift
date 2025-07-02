//
//  PRFeature.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 7/2/25.
//

import SwiftUI

struct WhatsNewFeature: Hashable {
  var title: String
  var subtitle: String
  var imageName: String
  var foregroundColor: Color?
}

struct WhatsNewArchive {
  private init() {}
  static let shared = WhatsNewArchive()
  
  let archive: [String : [WhatsNewFeature]] = [
    "1.3.0": [
      .init(
        title: "loc.v130.quiz_range_ui_update_title".localized,
        subtitle: "loc.v130.quiz_range_ui_update_body".localized,
        imageName: "v130_1"
      ),
      .init(
        title: "loc.v130.explanation_update_title".localized,
        subtitle: "loc.v130.explanation_update_body".localized,
        imageName: "v130_2"
      ),
    ],
  ]
  
  func callAsFunction(_ marketingVersion: String) -> [WhatsNewFeature]? {
    archive[marketingVersion]
  }
}

struct WhatsNewView: View {
  @Environment(\.presentationMode) var presentationMode
  let marketingVersion: String
  let features: [WhatsNewFeature]
  
  var body: some View {
    VStack {
      VStack(spacing: 20) {
        Text(verbatim: "loc.version_changes_title".localizedFormat(marketingVersion))
          .font(.largeTitle)
          .bold()
        Text(verbatim: "loc.version_changes_body".localizedFormat(marketingVersion))
          .foregroundColor(.gray)
          .font(.system(size: 14))
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 40)
      
      TabView {
        ForEach(features, id: \.self) { feature in
          VStack(alignment: .leading) {
            Image(feature.imageName)
              .resizable()
              .scaledToFit()
            Spacer(minLength: 20)
            Text(verbatim: feature.title)
              .font(.title2)
              .bold()
            Text(verbatim: feature.subtitle)
            Rectangle()
              .fill(Color.clear)
              .frame(height: 15)
          }
          .padding(.horizontal, 25)
          .padding(.vertical, 15)
        }
      }
      .tabViewStyle(.page)
      
      Spacer()
      
      ButtonProminent(title: "info_ok".localized) {
        presentationMode.wrappedValue.dismiss()
      }
      .font(.system(size: 17, weight: .bold))
    }
    .onAppear {
      UIPageControl.appearance().currentPageIndicatorTintColor = .frontLabel
      UIPageControl.appearance().pageIndicatorTintColor = UIColor.frontLabel.withAlphaComponent(0.2)
    }
  }
}

extension WhatsNewView {
  @ViewBuilder private func ButtonProminent(
    title: String,
    backgroundColor: Color = .blue,
    foregroundColor: Color = .white,
    completion: (() -> Void)? = nil
  ) -> some View {
    Button(title) {
      completion?()
    }
    .padding()
    .frame(
      width: UIScreen.main.bounds.width * 0.7,
      height: 50
    )
    .background(backgroundColor)
    .cornerRadius(10)
    .foregroundColor(foregroundColor)
  }
}

#Preview {
  WhatsNewView(
    marketingVersion: "1.3.0",
    features: WhatsNewArchive.shared("1.3.0") ?? []
  )
}
