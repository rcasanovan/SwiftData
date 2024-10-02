import ComposableArchitecture
import Foundation
import Testing

@testable import SwiftData_demo

struct TaskListTest {
  @Test @MainActor
  func testOnAppearDidReceiveTaskList() async {
    // Given
    let mockDatabaseManager = MockDatabaseManager(
      fetchResult: .success([
        TaskModel(id: "1", title: "Task 1"),
        TaskModel(id: "2", title: "Task 2"),
      ])
    )
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = TestStore(
      initialState: TaskList.State()
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.onAppear)

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    // Then
    await store.receive(.didReceiveTaskList(tasks)) {
      $0.tasks = tasks
    }
  }

  @Test @MainActor
  func testOnAppearDidReceiveError() async {
    // Given
    let mockDatabaseManager = MockDatabaseManager(
      fetchResult: .failure(
        NSError(domain: "", code: 0)
      )
    )
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = TestStore(
      initialState: TaskList.State()
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.onAppear)

    // Then
    await store.receive(.didReceiveError(.cannotLoadTasks(error: "The operation couldn’t be completed. ( error 0.)")))
  }

  @Test @MainActor
  func testDidReload() async {
    // Given
    let mockDatabaseManager = MockDatabaseManager(
      fetchResult: .success([
        TaskModel(id: "1", title: "Task 1"),
        TaskModel(id: "2", title: "Task 2"),
      ])
    )
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = TestStore(
      initialState: TaskList.State()
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.didReload)

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    // Then
    await store.receive(.didReceiveTaskList(tasks)) {
      $0.tasks = tasks
    }
  }

  @Test @MainActor
  func testDidTapOnAddTask() async {
    // Given
    var mockDatabaseManager = MockDatabaseManager()
    mockDatabaseManager.saveResult = .success(true)
    mockDatabaseManager.fetchResult = .success([
      TaskModel(id: "1", title: "Task 1"),
      TaskModel(id: "2", title: "Task 2"),
    ])
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = TestStore(
      initialState: TaskList.State()
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    // When
    await store.send(.didTapOnAddTask("Task 2"))

    // Then
    await store.receive(.didReload)

    await store.receive(.didReceiveTaskList(tasks)) {
      $0.tasks = tasks
    }
  }

  @Test @MainActor
  func testDidTapOnDeleteAllTasks() async {
    // Given
    var mockDatabaseManager = MockDatabaseManager()
    mockDatabaseManager.deleteAllResult = .success(true)
    mockDatabaseManager.fetchResult = .success([])
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = TestStore(
      initialState: TaskList.State()
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let tasks: [Task] = []

    // When
    await store.send(.didTapOnDeleteAllTasks)

    // Then
    await store.receive(.didReload)

    await store.receive(.didReceiveTaskList(tasks))
  }

  @Test @MainActor
  func testDidTapOnDeleteTask() async {
    // Given
    var mockDatabaseManager = MockDatabaseManager()
    mockDatabaseManager.deleteResult = .success(true)
    mockDatabaseManager.fetchResult = .success([])
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let store = TestStore(
      initialState: TaskList.State()
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let tasks: [Task] = []

    // When
    await store.send(.didTapOnDeleteTask(Task(id: "1", title: "Task 1")))

    // Then
    await store.receive(.didReload)

    await store.receive(.didReceiveTaskList(tasks))
  }
}