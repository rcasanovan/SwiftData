struct TaskListUseCaseSuccessMock: TaskListUseCase {
  func fetchTaskList() -> Result<[Task], Task.Error> {
    let tasks = [
      Task(id: "1", title: "Test Task 1", isCompleted: false),
      Task(id: "2", title: "Test Task 2", isCompleted: true),
    ]
    return .success(tasks)
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
