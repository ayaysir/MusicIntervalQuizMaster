//
//  MailRPView.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 12/1/24.
//

import SwiftUI
import MessageUI

// Identifiable을 준수하는 AlertItem 구조체 생성
struct AlertItem: Identifiable {
  let id = UUID() // Identifiable을 위한 고유 ID
  let message: String
}

struct MailRPView: UIViewControllerRepresentable {
  @Environment(\.dismiss) var dismiss
  var recipientEmail: String
  var subject: String
  var body: String
  
  static var canSendMail: Bool {
    MFMailComposeViewController.canSendMail()
  }
  
  func makeUIViewController(context: Context) -> MFMailComposeViewController {
    let mailComposeVC = MFMailComposeViewController()
    mailComposeVC.mailComposeDelegate = context.coordinator
    mailComposeVC.setToRecipients([recipientEmail])
    mailComposeVC.setSubject(subject)
    mailComposeVC.setMessageBody(body, isHTML: false)
    return mailComposeVC
  }
  
  func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(dismiss: dismiss)
  }
  
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    var dismiss: DismissAction
    
    init(dismiss: DismissAction) {
      self.dismiss = dismiss
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true)
      dismiss()
    }
  }
}
