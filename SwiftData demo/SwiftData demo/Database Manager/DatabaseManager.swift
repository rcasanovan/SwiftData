import SwiftData

public protocol DatabaseManager {
  func fetchTaskList() async -> Result<[TaskModel], Error>
  func saveTask(id: String, title: String, isCompleted: Bool) async -> Result<Bool, Error>
  func deleteAllTasks() async -> Result<Bool, Error>
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
  public func fetchTaskList() async -> Result<[TaskModel], Error> {
    do {
      let tasks = try modelContainer.mainContext.fetch(FetchDescriptor<TaskModel>())
      return .success(tasks)
    } catch (let error) {
      return .failure(error)
    }
  }

  @MainActor
  public func saveTask(id: String, title: String, isCompleted: Bool) async -> Result<Bool, Error> {
    let taskModel = TaskModel(
      id: id,
      title: title,
      isCompleted: isCompleted
    )
    modelContainer.mainContext.insert(taskModel)
    do {
      try modelContainer.mainContext.save()
      return .success(true)
    } catch (let error) {
      return .failure(error)
    }
  }
  @MainActor
  public func deleteAllTasks() async -> Result<Bool, Error> {
    do {
      let context = modelContainer.mainContext

      let allTasks = try context.fetch(FetchDescriptor<TaskModel>())

      for task in allTasks {
        context.delete(task)
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
