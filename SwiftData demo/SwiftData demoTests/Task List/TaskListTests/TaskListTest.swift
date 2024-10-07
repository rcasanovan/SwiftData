import ComposableArchitecture
import Foundation
import Testing

@testable import SwiftData_demo

struct TaskListTest {
  @Test @MainActor
  func testOnAppearDidReceiveTaskList() async {
    // Given
    let dataBaseManager = DatabaseManagerMock(
      fetchResult: .success([
        TaskModel(id: "1", title: "Task 1"),
        TaskModel(id: "2", title: "Task 2"),
      ])
    )
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let store = TestStore(
      initialState: TaskList.State(networkState: .ready)
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.onAppear) {
      $0.networkState = .loading
    }

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    // Then
    await store.receive(.didReceiveTaskList(tasks)) {
      $0.networkState = .completed(.success(tasks))
    }
  }

  @Test @MainActor
  func testOnAppearDidReceiveError() async {
    // Given
    let dataBaseManager = DatabaseManagerMock(
      fetchResult: .failure(
        NSError(domain: "", code: 0)
      )
    )
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let store = TestStore(
      initialState: TaskList.State(networkState: .ready)
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.onAppear) {
      $0.networkState = .loading
    }

    // Then
    await store.receive(.didReceiveError(.cannotLoadTasks(error: "The operation couldn’t be completed. ( error 0.)")))
  }

  @Test @MainActor
  func testDidReload() async {
    // Given
    let dataBaseManager = DatabaseManagerMock(
      fetchResult: .success([
        TaskModel(id: "1", title: "Task 1"),
        TaskModel(id: "2", title: "Task 2"),
      ])
    )
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let store = TestStore(
      initialState: TaskList.State(networkState: .ready)
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
      $0.networkState = .completed(.success(tasks))
    }
  }

  @Test @MainActor
  func testDidTapOnAddTask() async {
    // Given
    var dataBaseManager = DatabaseManagerMock()
    dataBaseManager.saveResult = .success(true)
    dataBaseManager.fetchResult = .success([
      TaskModel(id: "1", title: "Task 1"),
      TaskModel(id: "2", title: "Task 2"),
    ])
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let store = TestStore(
      initialState: TaskList.State(networkState: .ready)
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
      $0.networkState = .completed(.success(tasks))
    }
  }

  @Test @MainActor
  func testDidTapOnDeleteAllTasks() async {
    // Given
    var dataBaseManager = DatabaseManagerMock()
    dataBaseManager.deleteAllResult = .success(true)
    dataBaseManager.fetchResult = .success([])
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let store = TestStore(
      initialState: TaskList.State(networkState: .ready)
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let tasks: [Task] = []

    // When
    await store.send(.didTapOnDeleteAllTasks)

    // Then
    await store.receive(.didReload)

    await store.receive(.didReceiveTaskList(tasks)) {
      $0.networkState = .completed(.success([]))
    }
  }

  @Test @MainActor
  func testDidTapOnDeleteTask() async {
    // Given
    var dataBaseManager = DatabaseManagerMock()
    dataBaseManager.deleteResult = .success(true)
    dataBaseManager.fetchResult = .success([])
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let store = TestStore(
      initialState: TaskList.State(networkState: .ready)
    ) {
      TaskList(taskListUseCase: useCase)
    }

    let tasks: [Task] = []

    // When
    await store.send(.didTapOnDeleteTask(Task(id: "1", title: "Task 1")))

    // Then
    await store.receive(.didReload)

    await store.receive(.didReceiveTaskList(tasks)) {
      $0.networkState = .completed(.success(tasks))
    }
  }
}
