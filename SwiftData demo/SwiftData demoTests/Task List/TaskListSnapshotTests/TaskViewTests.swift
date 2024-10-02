import SnapshotTesting
import SwiftUI
import Testing

@testable import SwiftData_demo

struct TaskViewTests {
  var record: SnapshotTestingConfiguration.Record

  init() {
    record = .never
  }

  @Test @MainActor
  func testTaskView() {
    let view = TaskView_Preview.Preview()

    withSnapshotTesting(record: record) {
      assertSnapshot(of: view.colorScheme(.light), as: .deviceImage(), named: "light")
      assertSnapshot(of: view.colorScheme(.dark), as: .deviceImage(), named: "dark")
    }
  }
}
