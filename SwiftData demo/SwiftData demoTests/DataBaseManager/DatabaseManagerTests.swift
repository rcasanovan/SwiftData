import Foundation
import SwiftData
import Testing

@testable import SwiftData_demo

struct DatabaseManagerTests {
  var databaseManager: DatabaseManagerImp!

  init() {
    // Initial setup for each test
    let schema = Schema([TaskModel.self])
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: true  // Store only in memory for tests
    )
    databaseManager = DatabaseManagerImp(schema: schema, modelConfiguration: modelConfiguration)
  }

  // Test for saving a model
  @Test
  func testSaveModel() async throws {
    let task = TaskModel(id: "1", title: "Test Task", createdAt: Date().timeIntervalSince1970)

    let result = await databaseManager.save(model: task)

    switch result {
    case .success(let isSaved):
      #expect(isSaved == true, "The model should be saved successfully")
    case .failure(let error):
      throw error  // If there was an error, throw the exception to fail the test
    }
  }

  // Test for fetching an ordered model
  @Test
  func testFetchModel() async throws {
    // Save a model first
    let task = TaskModel(id: "1", title: "Fetch Task", createdAt: Date().timeIntervalSince1970)
    _ = await databaseManager.save(model: task)

    // Attempt to fetch the model
    let result = await databaseManager.fetch(ofType: TaskModel.self, sortBy: \.createdAt, ascending: true)

    switch result {
    case .success(let models):
      #expect(models.count == 1, "There should be only one saved model")
      #expect(models.first?.title == "Fetch Task", "The model title should be correct")
    case .failure(let error):
      throw error  // If there was an error, throw an exception
    }
  }

  // Test for deleting a model by ID
  @Test
  func testDeleteModel() async throws {
    let task = TaskModel(id: "1", title: "Task to Delete", createdAt: Date().timeIntervalSince1970)
    _ = await databaseManager.save(model: task)

    // Attempt to delete the model by ID
    let deleteResult = await databaseManager.delete(ofType: TaskModel.self, withId: "1")

    switch deleteResult {
    case .success(let isDeleted):
      #expect(isDeleted == true, "The model should be deleted successfully")
    case .failure(let error):
      throw error  // If there was an error, throw the exception to fail the test
    }

    // Verify there are no more models in the database
    let fetchResult = await databaseManager.fetch(ofType: TaskModel.self, sortBy: \.createdAt, ascending: true)

    switch fetchResult {
    case .success(let models):
      #expect(models.count == 0, "There should be no models after deletion")
    case .failure(let error):
      throw error
    }
  }

  // Test for deleting all models
  @Test
  func testDeleteAllModels() async throws {
    let task1 = TaskModel(id: "1", title: "Task 1", createdAt: Date().timeIntervalSince1970)
    let task2 = TaskModel(id: "2", title: "Task 2", createdAt: Date().timeIntervalSince1970)

    _ = await databaseManager.save(model: task1)
    _ = await databaseManager.save(model: task2)

    // Delete all models
    let deleteAllResult = await databaseManager.deleteAll(ofType: TaskModel.self)

    switch deleteAllResult {
    case .success(let deletedAll):
      #expect(deletedAll == true, "All models should be deleted successfully")
    case .failure(let error):
      throw error  // If there was an error, throw the exception to fail the test
    }

    // Verify there are no models after deletion
    let fetchResult = await databaseManager.fetch(ofType: TaskModel.self, sortBy: \.createdAt, ascending: true)

    switch fetchResult {
    case .success(let models):
      #expect(models.count == 0, "There should be no models after deleting all")
    case .failure(let error):
      throw error
    }
  }
}
