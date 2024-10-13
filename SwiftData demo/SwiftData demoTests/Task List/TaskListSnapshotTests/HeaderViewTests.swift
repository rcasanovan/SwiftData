import SnapshotTesting
import SwiftUI
import Testing

@testable import SwiftData_demo

struct HeaderViewTests {
  var record: SnapshotTestingConfiguration.Record

  init() {
    record = .never
  }

  @Test @MainActor
  func testHeaderViewIsDeleteAllDisabled() {
    let view = HeaderView_Preview.Preview(isDeleteAllDisabled: true)

    withSnapshotTesting(record: record) {
      assertSnapshot(of: view.colorScheme(.light), as: .deviceImage(), named: "light")
      assertSnapshot(of: view.colorScheme(.dark), as: .deviceImage(), named: "dark")
    }
  }

  @Test @MainActor
  func testHeaderViewIsDeleteAllEnabled() {
    let view = HeaderView_Preview.Preview(isDeleteAllDisabled: false)

    withSnapshotTesting(record: record) {
      assertSnapshot(of: view.colorScheme(.light), as: .deviceImage(), named: "light")
      assertSnapshot(of: view.colorScheme(.dark), as: .deviceImage(), named: "dark")
    }
  }
}
