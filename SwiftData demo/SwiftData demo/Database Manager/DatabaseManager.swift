import Foundation
import SwiftData

public protocol DatabaseManager {
  func fetch<Model: PersistentModel, T: Comparable>(
    ofType type: Model.Type,
    sortBy sortKeyPath: KeyPath<Model, T>,
    ascending: Bool,
    predicate: Predicate<Model>?
  ) async -> Result<[Model], Error>
  func save<Model: PersistentModel>(model: Model) async -> Result<Bool, Error>
  func deleteAll<Model: PersistentModel>(ofType type: Model.Type) async -> Result<Bool, Error>
}

public struct DatabaseManagerImp: DatabaseManager {
  private let modelContainer: ModelContainer

  init() {
    let modelContainer: ModelContainer

    let schema = Schema([
      TaskModel.self
    ])

    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false
    )

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
    ascending: Bool,
    predicate: Predicate<Model>?
  ) async -> Result<[Model], Error> {
    do {
      let sortDescriptor = SortDescriptor(sortKeyPath, order: ascending ? .forward : .reverse)

      // Descriptor de consulta con filtro (opcional) y ordenación
      var fetchDescriptor = FetchDescriptor<Model>(
        sortBy: [sortDescriptor]
      )

      // Si el filtro existe, lo agregamos al descriptor
      if let predicate = predicate {
        fetchDescriptor.predicate = predicate
      }

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
  public func deleteAll<Model: PersistentModel>(ofType type: Model.Type) async -> Result<Bool, Error> {
    do {
      let context = modelContainer.mainContext
      let allModels = try context.fetch(FetchDescriptor<Model>())

      for model in allModels {
        context.delete(model)
      }

      try context.save()

      return .success(true)
    } catch let error {
      return .failure(error)
    }
  }
}

extension DatabaseManagerImp {
  public static var live: DatabaseManager {
    DatabaseManagerImp()
  }
}
