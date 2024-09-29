import Combine
import SwiftUI

class KeyboardResponder: ObservableObject {
  @Published var currentHeight: CGFloat = 0
  private var cancellable: AnyCancellable?

  init() {
    cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
      .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
      .compactMap { notification -> CGFloat? in
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
          return notification.name == UIResponder.keyboardWillHideNotification ? 0 : keyboardFrame.height
        }
        return nil
      }
      .assign(to: \.currentHeight, on: self)
  }
}
