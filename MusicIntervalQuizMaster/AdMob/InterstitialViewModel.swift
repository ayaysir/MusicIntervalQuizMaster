//
//  InterstitialViewModel.swift
//  MusicIntervalQuizMaster
//
//  Created by 윤범태 on 5/2/26.
//

#if canImport(GoogleMobileAds)
import GoogleMobileAds

class InterstitialViewModel: NSObject, FullScreenContentDelegate {
  private var interstitialAd: InterstitialAd?

  func loadAd() async {
    do {
      interstitialAd = try await InterstitialAd.load(
        // with: "ca-app-pub-3940256099942544/4411468910", request: Request())
        with: "ca-app-pub-6364767349592629/8697349914", request: Request())
      interstitialAd?.fullScreenContentDelegate = self
    } catch {
      print("Failed to load interstitial ad with error: \(error.localizedDescription)")
    }
  }
  
  func showAd() {
    guard let interstitialAd = interstitialAd else {
      return print("Ad wasn't ready.")
    }

    interstitialAd.present(from: nil)
  }
  // MARK: - GADFullScreenContentDelegate methods

  func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  func adDidRecordClick(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  func ad(
    _ ad: FullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    print("\(#function) called")
  }

  func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
    // Clear the interstitial ad.
    interstitialAd = nil
  }
}

#endif
