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
    await store.receive(.didReceiveError(.cannotLoadTasks(error: "The operation couldn’t be completed. ( error 0.)"))) {
      $0.networkState = .completed(
        .failure(.cannotLoadTasks(error: "The operation couldn’t be completed. ( error 0.)"))
      )
    }
  }

  @Test @MainActor
  func testDidReload() async {
    // Given
    var dataBaseManager = DatabaseManagerMock()
    dataBaseManager.fetchResult = .success([
      TaskModel(id: "1", title: "Task 1"),
      TaskModel(id: "2", title: "Task 2"),
    ])
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    let store = TestStore(
      initialState: TaskList.State(networkState: .completed(.success(tasks)))
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.didReload)

    // Then
    await store.receive(.didReceiveTaskList(tasks))
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
    let dataBaseManager = DatabaseManagerMock(
      fetchResult: .success([]),
      deleteAllResult: .success(true)
    )
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    let store = TestStore(
      initialState: TaskList.State(networkState: .completed(.success(tasks)))
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.didTapOnDeleteAllTasks)

    // Then
    await store.receive(.didReload)

    await store.receive(.didReceiveTaskList([])) {
      $0.networkState = .completed(.success([]))
    }
  }

  @Test @MainActor
  func testDidTapOnDeleteTask() async {
    // Given
    let dataBaseManager = DatabaseManagerMock(
      fetchResult: .success([
        TaskModel(id: "2", title: "Task 2")
      ]),
      deleteResult: .success(true)
    )
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let task1 = Task(id: "1", title: "Task 1")
    let tasks = [
      task1,
      Task(id: "2", title: "Task 2"),
    ]

    let tasksAfterDelete = [
      Task(id: "2", title: "Task 2")
    ]

    let store = TestStore(
      initialState: TaskList.State(networkState: .completed(.success(tasks)))
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.didTapOnDeleteTask(task1))

    // Then
    await store.receive(.didReload)

    await store.receive(.didReceiveTaskList(tasksAfterDelete)) {
      $0.networkState = .completed(.success(tasksAfterDelete))
    }
  }

  @Test @MainActor
  func testSetShowAddTaskAlert() async {
    // Given
    let dataBaseManager = DatabaseManagerMock()
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    let store = TestStore(
      initialState: TaskList.State(networkState: .completed(.success(tasks)))
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.setShowAddTaskAlert(true)) {
      $0.showAddTaskAlert = true
    }
  }

  @Test @MainActor
  func testSetShowDeleteAllTasksAlert() async {
    // Given
    let dataBaseManager = DatabaseManagerMock()
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    let tasks = [
      Task(id: "1", title: "Task 1"),
      Task(id: "2", title: "Task 2"),
    ]

    let store = TestStore(
      initialState: TaskList.State(networkState: .completed(.success(tasks)))
    ) {
      TaskList(taskListUseCase: useCase)
    }

    // When
    await store.send(.setShowDeleteAllTasksAlert(true)) {
      $0.showDeleteAllTasksAlert = true
    }
  }
}
