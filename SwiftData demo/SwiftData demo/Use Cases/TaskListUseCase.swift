import Foundation

public struct Task: Equatable, Identifiable, Hashable {
  public let id: String
  let title: String
  let isCompleted: Bool

  init(title: String, isCompleted: Bool = false) {
    let combinedID =
      "\(Date().timeIntervalSince1970.description)\(title.replacingOccurrences(of: " ", with: ""))"
    // Hash the combined string to produce a unique identifier
    let hashID = combinedID.hash

    self.id = String(hashID)
    self.title = title
    self.isCompleted = isCompleted
  }

  init(id: String, title: String, isCompleted: Bool = false) {
    self.id = id
    self.title = title
    self.isCompleted = isCompleted
  }
}

// MARK: Errors
extension Task {
  public enum Error: Swift.Error, Equatable {
    case cannotLoadTasks(error: String)
    case cannotSaveTask(error: String)
  }
}

public protocol TaskListUseCase {
  func fetchTaskList() async -> Result<[Task], Task.Error>
  func saveTask(_ task: Task) async -> Result<Bool, Task.Error>
}

public struct TaskListUseCaseImpl: TaskListUseCase {
  let databaseManager: DatabaseManager

  public func fetchTaskList() async -> Result<[Task], Task.Error> {
    let result = await databaseManager.fetchTaskList()

    switch result {
    case .success(let dataModel):
      let tasks = dataModel.map { taskModel in
        Task(
          id: taskModel.id,
          title: taskModel.title,
          isCompleted: taskModel.isCompleted
        )
      }
      return .success(tasks)
    case .failure(let error):
      return .failure(.cannotSaveTask(error: error.localizedDescription))
    }
  }

  public func saveTask(_ task: Task) async -> Result<Bool, Task.Error> {
    let result = await databaseManager.saveTask(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted
    )

    switch result {
    case .success(let status):
      return .success(status)
    case .failure(let error):
      return .failure(.cannotSaveTask(error: error.localizedDescription))
    }
  }
}
