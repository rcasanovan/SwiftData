import Foundation

public struct Task: Equatable, Identifiable, Hashable {
  public let id: String
  let title: String

  init(title: String, isCompleted: Bool = false) {
    let combinedID =
      "\(Date().timeIntervalSince1970.description)\(title.replacingOccurrences(of: " ", with: ""))"
    // Hash the combined string to produce a unique identifier
    let hashID = combinedID.hash

    self.id = String(hashID)
    self.title = title
  }

  init(id: String, title: String, isCompleted: Bool = false) {
    self.id = id
    self.title = title
  }
}

// MARK: Errors
extension Task {
  public enum Error: Swift.Error, Equatable {
    case cannotLoadTasks(error: String)
    case cannotSaveTask(error: String)
    case cannotDeleteAllTasks(error: String)
  }
}

public protocol TaskListUseCase {
  func fetchTaskList() async -> Result<[Task], Task.Error>
  func saveTask(_ task: Task) async -> Result<Bool, Task.Error>
  func deleteTask(_ task: Task) async -> Result<Bool, Task.Error>
  func deleteAllTasks() async -> Result<Bool, Task.Error>
}

public struct TaskListUseCaseImpl: TaskListUseCase {
  let databaseManager: DatabaseManager

  public func fetchTaskList() async -> Result<[Task], Task.Error> {
    let result = await databaseManager.fetch(
      ofType: TaskModel.self,
      sortBy: \TaskModel.createdAt,
      ascending: false
    )

    switch result {
    case .success(let dataModel):
      let tasks = dataModel.map { taskModel in
        Task(
          id: taskModel.id,
          title: taskModel.title
        )
      }
      return .success(tasks)
    case .failure(let error):
      return .failure(.cannotSaveTask(error: error.localizedDescription))
    }
  }

  public func saveTask(_ task: Task) async -> Result<Bool, Task.Error> {
    let taskModel = TaskModel(
      id: task.id,
      title: task.title
    )
    let result = await databaseManager.save(model: taskModel)

    switch result {
    case .success(let status):
      return .success(status)
    case .failure(let error):
      return .failure(.cannotSaveTask(error: error.localizedDescription))
    }
  }

  public func deleteTask(_ task: Task) async -> Result<Bool, Task.Error> {
    let result = await databaseManager.delete(ofType: TaskModel.self, withId: task.id)

    switch result {
    case .success(let status):
      return .success(status)
    case .failure(let error):
      return .failure(.cannotSaveTask(error: error.localizedDescription))
    }
  }

  public func deleteAllTasks() async -> Result<Bool, Task.Error> {
    let result = await databaseManager.deleteAll(ofType: TaskModel.self)

    switch result {
    case .success(let status):
      return .success(status)
    case .failure(let error):
      return .failure(.cannotDeleteAllTasks(error: error.localizedDescription))
    }
  }
}
