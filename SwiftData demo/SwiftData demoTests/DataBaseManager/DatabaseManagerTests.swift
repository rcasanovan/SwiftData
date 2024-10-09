import Foundation
import SwiftData
import Testing

@testable import SwiftData_demo

struct DatabaseManagerTests {
  var databaseManager: DatabaseManagerImp!

  init() {
    // Configuración inicial para cada test
    let schema = Schema([TaskModel.self])
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: true  // Almacenar solo en memoria para los tests
    )
    databaseManager = DatabaseManagerImp(schema: schema, modelConfiguration: modelConfiguration)
  }

  // Test para guardar un modelo
  @Test
  func testSaveModel() async throws {
    let task = TaskModel(id: "1", title: "Test Task", createdAt: Date().timeIntervalSince1970)

    let result = await databaseManager.save(model: task)

    switch result {
    case .success(let isSaved):
      #expect(isSaved == true, "El modelo debería guardarse correctamente")
    case .failure(let error):
      throw error  // Si hubo un error, lanzar la excepción para que falle la prueba
    }
  }

  // Test para obtener un modelo ordenado
  @Test
  func testFetchModel() async throws {
    // Guarda un modelo primero
    let task = TaskModel(id: "1", title: "Fetch Task", createdAt: Date().timeIntervalSince1970)
    _ = await databaseManager.save(model: task)

    // Intenta obtener el modelo
    let result = await databaseManager.fetch(ofType: TaskModel.self, sortBy: \.createdAt, ascending: true)

    switch result {
    case .success(let models):
      #expect(models.count == 1, "Debería haber un solo modelo guardado")
      #expect(models.first?.title == "Fetch Task", "El título del modelo debería ser correcto")
    case .failure(let error):
      throw error  // Si hay un error, lanzar una excepción
    }
  }

  // Test para eliminar un modelo por ID
  @Test
  func testDeleteModel() async throws {
    let task = TaskModel(id: "1", title: "Task to Delete", createdAt: Date().timeIntervalSince1970)
    _ = await databaseManager.save(model: task)

    // Intenta eliminar el modelo por ID
    let deleteResult = await databaseManager.delete(ofType: TaskModel.self, withId: "1")

    switch deleteResult {
    case .success(let isDeleted):
      #expect(isDeleted == true, "El modelo debería eliminarse correctamente")
    case .failure(let error):
      throw error  // Si hubo un error, lanzar la excepción para que falle la prueba
    }

    // Verifica que no haya más modelos en la base de datos
    let fetchResult = await databaseManager.fetch(ofType: TaskModel.self, sortBy: \.createdAt, ascending: true)

    switch fetchResult {
    case .success(let models):
      #expect(models.count == 0, "No debería haber modelos después de la eliminación")
    case .failure(let error):
      throw error
    }
  }

  // Test para eliminar todos los modelos
  @Test
  func testDeleteAllModels() async throws {
    let task1 = TaskModel(id: "1", title: "Task 1", createdAt: Date().timeIntervalSince1970)
    let task2 = TaskModel(id: "2", title: "Task 2", createdAt: Date().timeIntervalSince1970)

    _ = await databaseManager.save(model: task1)
    _ = await databaseManager.save(model: task2)

    // Eliminar todos los modelos
    let deleteAllResult = await databaseManager.deleteAll(ofType: TaskModel.self)

    switch deleteAllResult {
    case .success(let deletedAll):
      #expect(deletedAll == true, "Todos los modelos deberían eliminarse correctamente")
    case .failure(let error):
      throw error  // Si hubo un error, lanzar la excepción para que falle la prueba
    }

    // Verifica que no haya modelos después de la eliminación
    let fetchResult = await databaseManager.fetch(ofType: TaskModel.self, sortBy: \.createdAt, ascending: true)

    switch fetchResult {
    case .success(let models):
      #expect(models.count == 0, "No debería haber modelos después de eliminar todos")
    case .failure(let error):
      throw error
    }
  }
}
