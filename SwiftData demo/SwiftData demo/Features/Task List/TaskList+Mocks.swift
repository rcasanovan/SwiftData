#if DEBUG

/// Predefined states for the `TaskList.State` to simplify testing and initialization.
///
/// - `loading`: Represents the state where tasks are being loaded, with `networkState` set to `.loading`.
/// - `success`: Represents the state where tasks were successfully loaded, with `networkState` set to `.completed` with mock data.
/// - `failure`: Represents the state where task loading failed, with `networkState` set to `.completed` with an error.
/// - `showAddTaskAlert`: Represents the state where the alert for adding a new task is visible.
/// - `showDeleteAllTasksAlert`: Represents the state where the alert for deleting all tasks is visible.
extension TaskList.State {
  static let loading = Self(networkState: .loading)

  static let success = Self(networkState: .completed(.success(.mock)))

  static let failure = Self(networkState: .completed(.failure(.cannotLoadTasks(error: "error"))))

  static let showAddTaskAlert = Self(networkState: .completed(.success(.mock)), showAddTaskAlert: true)

  static let showDeleteAllTasksAlert = Self(networkState: .completed(.success(.mock)), showDeleteAllTasksAlert: true)
}

extension Array where Element == Task {
  static let mock = Self([
    .init(id: "6", title: "Task 6"),
    .init(id: "5", title: "Task 5"),
    .init(id: "4", title: "Task 4"),
    .init(id: "3", title: "Task 3"),
    .init(id: "2", title: "Task 2"),
    .init(id: "1", title: "Task 1"),
  ])
}

struct TaskListUseCaseSuccessMock: TaskListUseCase {
  func fetchTaskList() -> Result<[Task], Task.Error> {
    return .success(.mock)
  }

  func saveTask(_ task: Task) -> Result<Bool, Task.Error> {
    return .success(true)
  }

  func deleteTask(_ task: Task) -> Result<Bool, Task.Error> {
    return .success(true)
  }

  func deleteAllTasks() async -> Result<Bool, Task.Error> {
    return .success(true)
  }
}

#endif
