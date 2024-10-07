import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import Testing

@testable import SwiftData_demo

struct TaskListViewTests {
  var record: SnapshotTestingConfiguration.Record

  init() {
    record = .never
  }

  @Test @MainActor
  func testTaskListViewLoadingState() {
    let mockDatabaseManager = MockDatabaseManager(
      fetchResult: .success([
        TaskModel(id: "1", title: "Task 1"),
        TaskModel(id: "2", title: "Task 2"),
        TaskModel(id: "3", title: "Task 3"),
        TaskModel(id: "4", title: "Task 4"),
        TaskModel(id: "5", title: "Task 5"),
        TaskModel(id: "6", title: "Task 6"),
      ])
    )
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = StoreOf<TaskList>(
      initialState: .loading
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let view =
      TaskListView_Preview.Preview(
        store: store
      )

    withSnapshotTesting(record: record) {
      assertSnapshot(of: view.colorScheme(.light), as: .deviceImage(), named: "light")
      assertSnapshot(of: view.colorScheme(.dark), as: .deviceImage(), named: "dark")
    }
  }

  @Test @MainActor
  func testTaskListViewSuccessState() {
    let mockDatabaseManager = MockDatabaseManager(
      fetchResult: .success([
        TaskModel(id: "1", title: "Task 1"),
        TaskModel(id: "2", title: "Task 2"),
        TaskModel(id: "3", title: "Task 3"),
        TaskModel(id: "4", title: "Task 4"),
        TaskModel(id: "5", title: "Task 5"),
        TaskModel(id: "6", title: "Task 6"),
      ])
    )
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = StoreOf<TaskList>(
      initialState: .success
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let view =
      TaskListView_Preview.Preview(
        store: store
      )

    withSnapshotTesting(record: record) {
      assertSnapshot(of: view.colorScheme(.light), as: .deviceImage(), named: "light")
      assertSnapshot(of: view.colorScheme(.dark), as: .deviceImage(), named: "dark")
    }
  }

  @Test @MainActor
  func testTaskListViewFailureState() {
    let mockDatabaseManager = MockDatabaseManager(
      fetchResult: .failure(
        NSError(domain: "", code: 0)
      )
    )
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = StoreOf<TaskList>(
      initialState: .failure
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let view =
      TaskListView_Preview.Preview(
        store: store
      )

    withSnapshotTesting(record: record) {
      assertSnapshot(of: view.colorScheme(.light), as: .deviceImage(), named: "light")
      assertSnapshot(of: view.colorScheme(.dark), as: .deviceImage(), named: "dark")
    }
  }
}
