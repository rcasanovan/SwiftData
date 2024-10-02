import Foundation
import SwiftData

#if DEBUG

struct MockDatabaseManager: DatabaseManager {
  // Variables para almacenar resultados simulados
  var fetchResult: Result<[TaskModel], Error>?
  var saveResult: Result<Bool, Error>?
  var deleteResult: Result<Bool, Error>?
  var deleteAllResult: Result<Bool, Error>?

  // Implementaciones de los métodos del protocolo
  func fetch<Model: PersistentModel, T: Comparable>(
    ofType type: Model.Type,
    sortBy sortKeyPath: KeyPath<Model, T>,
    ascending: Bool
  ) async -> Result<[Model], Error> {
    // Usa un casting seguro
    if let fetchResult = fetchResult {
      // Convertir el resultado a el tipo correspondiente
      switch fetchResult {
      case .success(let taskModels):
        // Convierte el tipo TaskModel a Model
        let models = taskModels as? [Model] ?? []
        return .success(models)
      case .failure(let error):
        return .failure(error)
      }
    }
    return .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No hay resultado para fetch"]))
  }

  func save<Model: PersistentModel>(model: Model) async -> Result<Bool, Error> {
    return saveResult ?? .failure(NSError(domain: "", code: 0))
  }

  func delete<Model: PersistentModel & IdentifiableModel>(
    ofType type: Model.Type,
    withId id: String
  ) async -> Result<Bool, Error> {
    return deleteResult ?? .failure(NSError(domain: "", code: 0))
  }

  func deleteAll<Model: PersistentModel>(ofType type: Model.Type) async -> Result<Bool, Error> {
    return deleteAllResult ?? .failure(NSError(domain: "", code: 0))
  }
}

#endif
