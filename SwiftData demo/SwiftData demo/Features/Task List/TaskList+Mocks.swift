#if DEBUG

extension TaskList.State {
  static let loading = Self(networkState: .loading)

  static let success = Self(networkState: .completed(.success(.mock)))

  static let failure = Self(networkState: .completed(.failure(.cannotLoadTasks(error: "error"))))
}

extension Array where Element == Task {
  static let mock = Self([
    .init(id: "1", title: "Task 1"),
    .init(id: "2", title: "Task 2"),
    .init(id: "3", title: "Task 3"),
    .init(id: "4", title: "Task 4"),
    .init(id: "5", title: "Task 5"),
    .init(id: "6", title: "Task 6"),
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
