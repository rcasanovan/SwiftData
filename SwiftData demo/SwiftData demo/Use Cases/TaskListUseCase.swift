import Foundation

/// A structure representing a task.
///
/// The `Task` struct conforms to `Equatable`, `Identifiable`, and `Hashable` protocols.
/// It contains a unique identifier (`id`) and a title (`title`).
/// The initializer generates a unique `id` by hashing a combination of the current timestamp and the title (with spaces removed).
public struct Task: Equatable, Identifiable, Hashable {
  public let id: String
  let title: String

  init(title: String) {
    let combinedID =
      "\(Date().timeIntervalSince1970.description)\(title.replacingOccurrences(of: " ", with: ""))"
    // Hash the combined string to produce a unique identifier
    let hashID = combinedID.hash

    self.id = String(hashID)
    self.title = title
  }

  init(id: String, title: String) {
    self.id = id
    self.title = title
  }
}

// MARK: Errors

/// An enumeration representing possible errors that can occur with tasks.
extension Task {
  public enum Error: Swift.Error, Equatable {
    case cannotLoadTasks(error: String)  // Error when tasks cannot be loaded
    case cannotSaveTask(error: String)  // Error when a task cannot be saved
    case cannotDeleteAllTasks(error: String)  // Error when all tasks cannot be deleted
  }
}

public protocol TaskListUseCase {
  /// Fetches the list of tasks asynchronously.
  /// - Returns: A `Result` containing an array of `Task` on success or a `Task.Error` on failure.
  func fetchTaskList() async -> Result<[Task], Task.Error>
  /// Saves a given task asynchronously.
  /// - Parameter task: The `Task` to be saved.
  /// - Returns: A `Result` indicating success or a `Task.Error` on failure.
  func saveTask(_ task: Task) async -> Result<Bool, Task.Error>
  /// Deletes a specified task asynchronously.
  /// - Parameter task: The `Task` to be deleted.
  /// - Returns: A `Result` indicating success or a `Task.Error` on failure.
  func deleteTask(_ task: Task) async -> Result<Bool, Task.Error>
  /// Deletes all tasks asynchronously.
  /// - Returns: A `Result` indicating success or a `Task.Error` on failure.
  func deleteAllTasks() async -> Result<Bool, Task.Error>
}

/// An implementation of the `TaskListUseCase` protocol for managing tasks.
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
      return .failure(.cannotLoadTasks(error: error.localizedDescription))
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
