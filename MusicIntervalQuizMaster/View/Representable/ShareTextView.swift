//
//  ShareTextView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 2/15/25.
//

import SwiftUI
import UIKit

struct ShareTextView: UIViewControllerRepresentable {
  let text: String
  let fileName: String
  let fileExt: String = "csv"

  func makeUIViewController(context: Context) -> UIActivityViewController {
    // 공유할 텍스트를 파일로 변환
    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).\(fileExt)")
    try? text.write(to: tempURL, atomically: true, encoding: .utf8)
    
    let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
    
    return activityVC
  }

  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
