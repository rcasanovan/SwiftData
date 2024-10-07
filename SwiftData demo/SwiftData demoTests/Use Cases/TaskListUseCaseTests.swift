import Foundation
import Testing

@testable import SwiftData_demo

struct TaskListUseCaseTests {

  @Test
  func testFetchTaskListSuccess() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(fetchResult: .success([TaskModel(id: "1", title: "Task 1")]))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    // Whwn
    let result = await useCase.fetchTaskList()

    // Then
    switch result {
    case .success(let tasks):
      #expect(tasks.count == 1, "There should be one task")
      #expect(tasks.first?.title == "Task 1", "The task title should be 'Task 1'")
    case .failure:
      #expect(Bool(false), "The fetch should not fail")
    }
  }

  @Test
  func testFetchTaskListFailure() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(fetchResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    // When
    let result = await useCase.fetchTaskList()

    // Then
    switch result {
    case .success:
      #expect(Bool(false), "The fetch should fail")
    case .failure(let error):
      #expect(
        error == .cannotLoadTasks(error: "The operation couldn’t be completed. ( error 0.)"),
        "The error message should match"
      )
    }
  }

  @Test
  func testSaveTaskSuccess() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(saveResult: .success(true))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)
    let task = Task(id: "1", title: "Test Task")

    // When
    let result = await useCase.saveTask(task)

    // Then
    switch result {
    case .success(let status):
      #expect(status == true, "The task should be saved successfully")
    case .failure:
      #expect(Bool(false), "The save should not fail")
    }
  }

  @Test
  func testSaveTaskFailure() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(saveResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)
    let task = Task(id: "1", title: "Test Task")

    // When
    let result = await useCase.saveTask(task)

    // Then
    switch result {
    case .success:
      #expect(Bool(false), "The save should fail")
    case .failure(let error):
      #expect(
        error == .cannotSaveTask(error: "The operation couldn’t be completed. ( error 0.)"),
        "The error message should match"
      )
    }
  }

  @Test
  func testDeleteTaskSuccess() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(deleteResult: .success(true))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)
    let task = Task(id: "1", title: "Test Task")

    // When
    let result = await useCase.deleteTask(task)

    // Then
    switch result {
    case .success(let status):
      #expect(status == true, "The task should be deleted successfully")
    case .failure:
      #expect(Bool(false), "The deletion should not fail")
    }
  }

  @Test
  func testDeleteTaskFailure() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(deleteResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)
    let task = Task(id: "1", title: "Test Task")

    // When
    let result = await useCase.deleteTask(task)

    // Then
    switch result {
    case .success:
      #expect(Bool(false), "The deletion should fail")
    case .failure(let error):
      #expect(
        error == .cannotSaveTask(error: "The operation couldn’t be completed. ( error 0.)"),
        "The error message should match"
      )
    }
  }

  @Test
  func testDeleteAllTasksSuccess() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(deleteAllResult: .success(true))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    // When
    let result = await useCase.deleteAllTasks()

    // Then
    switch result {
    case .success(let status):
      #expect(status == true, "All tasks should be deleted successfully")
    case .failure:
      #expect(Bool(false), "The deletion should not fail")
    }
  }

  @Test
  func testDeleteAllTasksFailure() async throws {
    // Given
    let dataBaseManager = DatabaseManagerMock(deleteAllResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: dataBaseManager)

    // When
    let result = await useCase.deleteAllTasks()

    // Then
    switch result {
    case .success:
      #expect(Bool(false), "The deletion should fail")
    case .failure(let error):
      #expect(
        error == .cannotDeleteAllTasks(error: "The operation couldn’t be completed. ( error 0.)"),
        "The error message should match"
      )
    }
  }
}
