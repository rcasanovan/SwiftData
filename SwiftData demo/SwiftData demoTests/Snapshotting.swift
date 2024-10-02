import SnapshotTesting
import SwiftUI

/// A Snapshotting extenstion to manage the device image for the snapshot tests
extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
  public static func deviceImage(
    on deviceConfig: ViewImageConfig = .iPhone13Pro,
    perceptualPrecision: Float = 0.99
  ) -> Snapshotting {
    .image(
      drawHierarchyInKeyWindow: false,
      perceptualPrecision: perceptualPrecision,
      layout: .device(config: deviceConfig)
    )
  }
}
