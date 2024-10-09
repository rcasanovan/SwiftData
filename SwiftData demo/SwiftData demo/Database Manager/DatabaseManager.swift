import Foundation
import SwiftData

/// A protocol that defines the operations for managing database interactions.
///
/// The `DatabaseManager` protocol requires conforming types to implement methods for fetching,
/// saving, and deleting persistent models in the database.
public protocol DatabaseManager {
  /// Fetches an array of persistent models of the specified type, sorted by the given key path.
  ///
  /// - Parameters:
  ///   - type: The model type to fetch.
  ///   - sortKeyPath: The key path used for sorting the fetched models.
  ///   - ascending: A Boolean indicating whether the sorting should be in ascending order.
  /// - Returns: A result containing an array of fetched models or an error.
  func fetch<Model: PersistentModel, T: Comparable>(
    ofType type: Model.Type,
    sortBy sortKeyPath: KeyPath<Model, T>,
    ascending: Bool
  ) async -> Result<[Model], Error>

  /// Saves the given model to the database.
  ///
  /// - Parameter model: The model to save.
  /// - Returns: A result indicating the success status or an error.
  func save<Model: PersistentModel>(model: Model) async -> Result<Bool, Error>

  /// Deletes a persistent model of the specified type with the given identifier.
  ///
  /// - Parameters:
  ///   - type: The model type to delete.
  ///   - id: The identifier of the model to delete.
  /// - Returns: A result indicating the success status or an error.
  func delete<Model: PersistentModel & IdentifiableModel>(
    ofType type: Model.Type,
    withId id: String
  ) async -> Result<Bool, Error>

  /// Deletes all persistent models of the specified type from the database.
  ///
  /// - Parameter type: The model type to delete all instances of.
  /// - Returns: A result indicating the success status or an error.
  func deleteAll<Model: PersistentModel>(ofType type: Model.Type) async -> Result<Bool, Error>
}

/// A concrete implementation of the `DatabaseManager` protocol, handling database operations.
///
/// The `DatabaseManagerImp` class provides methods for fetching, saving, and deleting models
/// from the database, utilizing a `ModelContainer` for context management.
public struct DatabaseManagerImp: DatabaseManager {
  private let modelContainer: ModelContainer

  init(schema: Schema, modelConfiguration: ModelConfiguration) {
    let modelContainer: ModelContainer

    do {
      modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }

    self.modelContainer = modelContainer
  }

  @MainActor
  public func fetch<Model: PersistentModel, T: Comparable>(
    ofType type: Model.Type,
    sortBy sortKeyPath: KeyPath<Model, T>,
    ascending: Bool
  ) async -> Result<[Model], Error> {
    do {
      let sortDescriptor = SortDescriptor(sortKeyPath, order: ascending ? .forward : .reverse)

      let fetchDescriptor = FetchDescriptor<Model>(
        sortBy: [sortDescriptor]
      )

      let models = try modelContainer.mainContext.fetch(fetchDescriptor)
      return .success(models)
    } catch let error {
      return .failure(error)
    }
  }

  @MainActor
  public func save<Model: PersistentModel>(model: Model) async -> Result<Bool, Error> {
    modelContainer.mainContext.insert(model)
    do {
      try modelContainer.mainContext.save()
      return .success(true)
    } catch let error {
      return .failure(error)
    }
  }

  @MainActor
  public func delete<Model: PersistentModel & IdentifiableModel>(
    ofType type: Model.Type,
    withId id: String
  ) async -> Result<Bool, Error> {
    do {
      let context = modelContainer.mainContext

      let fetchDescriptor = FetchDescriptor<Model>(
        predicate: #Predicate { $0.id == id }
      )

      if let result = try modelContainer.mainContext.fetch(fetchDescriptor).first {
        context.delete(result)
        try context.save()
        return .success(true)
      } else {
        return .failure(NSError(domain: "No object was found with the specified ID.", code: 404, userInfo: nil))
      }
    } catch let error {
      return .failure(error)
    }
  }

  @MainActor
  public func deleteAll<Model: PersistentModel>(ofType type: Model.Type) async -> Result<Bool, Error> {
    do {
      let context = modelContainer.mainContext
      try context.delete(model: Model.self)

      try context.save()

      return .success(true)
    } catch let error {
      return .failure(error)
    }
  }
}

extension DatabaseManagerImp {
  public static var live: DatabaseManager {
    let schema = Schema([
      TaskModel.self
    ])

    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false
    )

    return DatabaseManagerImp(
      schema: schema,
      modelConfiguration: modelConfiguration
    )
  }
}
