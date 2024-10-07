import Foundation
import SwiftData

public protocol DatabaseManager {
  func fetch<Model: PersistentModel, T: Comparable>(
    ofType type: Model.Type,
    sortBy sortKeyPath: KeyPath<Model, T>,
    ascending: Bool
  ) async -> Result<[Model], Error>
  func save<Model: PersistentModel>(model: Model) async -> Result<Bool, Error>
  func delete<Model: PersistentModel & IdentifiableModel>(
    ofType type: Model.Type,
    withId id: String
  ) async -> Result<Bool, Error>
  func deleteAll<Model: PersistentModel>(ofType type: Model.Type) async -> Result<Bool, Error>
}

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
        return .failure(NSError(domain: "No se encontró un objeto con el ID especificado.", code: 404, userInfo: nil))
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
