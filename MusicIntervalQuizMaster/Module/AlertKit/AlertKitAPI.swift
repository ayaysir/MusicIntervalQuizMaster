import UIKit

public enum AlertKitAPI {
  
  public static func present(view: AlertViewProtocol, completion: @escaping ()->Void = {}) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
    view.present(on: window, completion: completion)
  }
  
  public static func present(title: String? = nil, subtitle: String? = nil, icon: AlertIcon? = nil, style: AlertViewStyle, haptic: AlertHaptic? = nil) {
    switch style {
#if os(iOS)
    case .iOS16AppleMusic:
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
      let view = AlertAppleMusic16View(title: title, subtitle: subtitle, icon: icon)
      view.haptic = haptic
      view.present(on: window)
#endif
#if os(iOS) || os(visionOS)
    case .iOS17AppleMusic:
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
      let view = AlertAppleMusic17View(title: title, subtitle: subtitle, icon: icon)
      view.haptic = haptic
      view.present(on: window)
#endif
    }
  }
  
  /**
   Call only with this one `completion`. Internal ones is canceled.
   */
  public static func dismissAllAlerts(completion: (() -> Void)? = nil) {
    
    var alertViews: [AlertViewInternalDismissProtocol] = []
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return
    }
    for window in windowScene.windows {
      for view in window.subviews {
        if let view = view as? AlertViewInternalDismissProtocol {
          alertViews.append(view)
        }
      }
    }
    
    if alertViews.isEmpty {
      completion?()
    } else {
      for (index, view) in alertViews.enumerated() {
        if index == .zero {
          view.dismiss(customCompletion: {
            completion?()
          })
        } else {
          view.dismiss(customCompletion: nil)
        }
      }
    }
  }
}
