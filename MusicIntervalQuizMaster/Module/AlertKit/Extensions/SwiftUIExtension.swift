import SwiftUI

@available(iOS 13.0, *)
extension View {
    
    public func alert(isPresent: Binding<Bool>, view: AlertViewProtocol, completion: (()->Void)? = nil) -> some View {
        if isPresent.wrappedValue {
            let wrapperCompletion = {
                isPresent.wrappedValue = false
                completion?()
            }
            // if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            //     view.present(on: window, completion: wrapperCompletion)
            // }
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
              view.present(on: window, completion: wrapperCompletion)
            }
        }
        return self
    }
}
