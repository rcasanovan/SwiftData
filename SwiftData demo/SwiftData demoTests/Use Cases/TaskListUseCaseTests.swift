import Foundation
import Testing

@testable import SwiftData_demo

struct TaskListUseCaseTests {

  @Test
  func testFetchTaskListSuccess() async throws {
    // Mock del DatabaseManager que simula una respuesta exitosa
    let mockDatabaseManager = MockDatabaseManager(fetchResult: .success([TaskModel(id: "1", title: "Task 1")]))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let result = await useCase.fetchTaskList()

    switch result {
    case .success(let tasks):
      #expect(tasks.count == 1, "Debería haber una tarea")
      #expect(tasks.first?.title == "Task 1", "El título de la tarea debería ser 'Task 1'")
    case .failure:
      #expect(Bool(false), "El fetch no debería fallar")
    }
  }

  @Test
  func testFetchTaskListFailure() async throws {
    // Mock del DatabaseManager que simula un fallo
    let mockDatabaseManager = MockDatabaseManager(fetchResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let result = await useCase.fetchTaskList()

    switch result {
    case .success:
      #expect(Bool(false), "El fetch debería fallar")
    case .failure(let error):
      #expect(
        error == .cannotLoadTasks(error: "The operation couldn’t be completed. ( error 0.)"),
        "El mensaje de error debería coincidir"
      )
    }
  }

  @Test
  func testSaveTaskSuccess() async throws {
    // Mock del DatabaseManager que simula un guardado exitoso
    let mockDatabaseManager = MockDatabaseManager(saveResult: .success(true))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let task = Task(id: "1", title: "Test Task")
    let result = await useCase.saveTask(task)

    switch result {
    case .success(let status):
      #expect(status == true, "La tarea debería guardarse correctamente")
    case .failure:
      #expect(Bool(false), "El guardado no debería fallar")
    }
  }

  @Test
  func testSaveTaskFailure() async throws {
    // Mock del DatabaseManager que simula un fallo al guardar
    let mockDatabaseManager = MockDatabaseManager(saveResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let task = Task(id: "1", title: "Test Task")
    let result = await useCase.saveTask(task)

    switch result {
    case .success:
      #expect(Bool(false), "El guardado debería fallar")
    case .failure(let error):
      #expect(
        error == .cannotSaveTask(error: "The operation couldn’t be completed. ( error 0.)"),
        "El mensaje de error debería coincidir"
      )
    }
  }

  @Test
  func testDeleteTaskSuccess() async throws {
    // Mock del DatabaseManager que simula una eliminación exitosa
    let mockDatabaseManager = MockDatabaseManager(deleteResult: .success(true))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let task = Task(id: "1", title: "Test Task")
    let result = await useCase.deleteTask(task)

    switch result {
    case .success(let status):
      #expect(status == true, "La tarea debería eliminarse correctamente")
    case .failure:
      #expect(false, "La eliminación no debería fallar")
    }
  }

  @Test
  func testDeleteTaskFailure() async throws {
    // Mock del DatabaseManager que simula un fallo al eliminar
    let mockDatabaseManager = MockDatabaseManager(deleteResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let task = Task(id: "1", title: "Test Task")
    let result = await useCase.deleteTask(task)

    switch result {
    case .success:
      #expect(false, "La eliminación debería fallar")
    case .failure(let error):
      #expect(
        error == .cannotSaveTask(error: "The operation couldn’t be completed. ( error 0.)"),
        "El mensaje de error debería coincidir"
      )
    }
  }

  @Test
  func testDeleteAllTasksSuccess() async throws {
    // Mock del DatabaseManager que simula una eliminación exitosa de todas las tareas
    let mockDatabaseManager = MockDatabaseManager(deleteAllResult: .success(true))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let result = await useCase.deleteAllTasks()

    switch result {
    case .success(let status):
      #expect(status == true, "Todas las tareas deberían eliminarse correctamente")
    case .failure:
      #expect(false, "La eliminación no debería fallar")
    }
  }

  @Test
  func testDeleteAllTasksFailure() async throws {
    // Mock del DatabaseManager que simula un fallo al eliminar todas las tareas
    let mockDatabaseManager = MockDatabaseManager(deleteAllResult: .failure(NSError(domain: "", code: 0)))
    let useCase = TaskListUseCaseImpl(databaseManager: mockDatabaseManager)

    let result = await useCase.deleteAllTasks()

    switch result {
    case .success:
      #expect(false, "La eliminación debería fallar")
    case .failure(let error):
      #expect(
        error == .cannotDeleteAllTasks(error: "The operation couldn’t be completed. ( error 0.)"),
        "El mensaje de error debería coincidir"
      )
    }
  }
}
