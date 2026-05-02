//
//  OpenURL.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 5/2/26.
//

import UIKit

func openExternalLink(urlString: String) {
  // "https://apps.apple.com/developer/id1578285460"
  // "https://apps.apple.com/app/id<YOUR_APP_ID>?action=write-review"
  if let url = URL(string: urlString),
     UIApplication.shared.canOpenURL(url) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
