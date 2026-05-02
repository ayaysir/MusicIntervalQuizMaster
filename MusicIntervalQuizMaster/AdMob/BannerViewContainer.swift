//
//  BannerViewContainer.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 5/2/26.
//

import SwiftUI

#if canImport(GoogleMobileAds)
import GoogleMobileAds

struct BannerViewContainer: UIViewRepresentable {
  typealias UIViewType = BannerView
  let adSize: AdSize
  
  init(_ adSize: AdSize) {
    self.adSize = adSize
  }
  
  func makeUIView(context: Context) -> BannerView {
    let banner = BannerView(adSize: adSize)
    // banner.adUnitID = "ca-app-pub-3940256099942544/2435281174" // TEST
    banner.adUnitID = "ca-app-pub-6364767349592629/2664182196"
    banner.load(Request())
    banner.delegate = context.coordinator
    return banner
  }
  
  func updateUIView(_ uiView: BannerView, context: Context) {}
  
  func makeCoordinator() -> BannerCoordinator {
    return BannerCoordinator(self)
  }
  
  class BannerCoordinator: NSObject, BannerViewDelegate {

    let parent: BannerViewContainer

    init(_ parent: BannerViewContainer) {
      self.parent = parent
    }

    // MARK: - GADBannerViewDelegate methods

    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
      print("DID RECEIVE AD.")
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
      print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
    }
  }
}
#endif
