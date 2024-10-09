import ComposableArchitecture
import Foundation

@Reducer
public struct TaskList {
  @ObservableState
  public struct State: Equatable {
    // The current network state for the feature
    public var networkState: NetworkState<[Task], Task.Error>
    // A boolean to show or hide the alert for adding a new task. Its default value will be false
    public var showAddTaskAlert: Bool
    // A boolean to show or hide the alert for deleting all tasks. Its default value will be false
    public var showDeleteAllTasksAlert: Bool

    public init(
      networkState: NetworkState<[Task], Task.Error>,
      showAddTaskAlert: Bool = false,
      showDeleteAllTasksAlert: Bool = false
    ) {
      self.networkState = networkState
      self.showAddTaskAlert = showAddTaskAlert
      self.showDeleteAllTasksAlert = showDeleteAllTasksAlert
    }
  }

  public enum Action: Equatable {
    // An error was received while obtaining the required information
    case didReceiveError(Task.Error)
    // Task list has been received
    case didReceiveTaskList([Task])
    // The action to reload the information has been received
    case didReload
    // The user has tapped on the action to add a task with the title passed as a parameter
    case didTapOnAddTask(String)
    // The user has tapped on the action to delete all tasks
    case didTapOnDeleteAllTasks
    // The user has tapped on the action to delete a specific task
    case didTapOnDeleteTask(Task)
    // Action to capture the onAppear of the view
    case onAppear
    // Action to set the state to show or hide the alert to add a task
    case setShowAddTaskAlert(Bool)
    // Action to set the state to show or hide the alert to delete all tasks
    case setShowDeleteAllTasksAlert(Bool)
  }

  // Use case for task management
  private let taskListUseCase: TaskListUseCase

  public init(taskListUseCase: TaskListUseCase) {
    self.taskListUseCase = taskListUseCase
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didReceiveError(let error):
        state.networkState = .completed(.failure(error))
        return .none
      case .didReceiveTaskList(let tasks):
        state.networkState = .completed(.success(tasks))
        return .none
      case .didReload:
        return self.loadEffect()
      case .didTapOnAddTask(let title):
        return self.saveTaskEffect(Task(title: title))
      case .didTapOnDeleteAllTasks:
        return self.deleteAllTasksEffect()
      case .didTapOnDeleteTask(let task):
        return self.deleteTaskEffect(task)
      case .onAppear:
        guard case .ready = state.networkState else {
          return .none
        }

        state.networkState = .loading
        return self.loadEffect()
      case .setShowAddTaskAlert(let showAlert):
        state.showAddTaskAlert = showAlert
        return .none
      case .setShowDeleteAllTasksAlert(let showAlert):
        state.showDeleteAllTasksAlert = showAlert
        return .none
      }
    }
  }
}

extension TaskList {
  /// Saves a task and sends an appropriate action based on the result.
  ///
  /// - Parameter task: The `Task` object that needs to be saved.
  /// - Returns: An `Effect` that sends a `TaskList.Action` based on the result of the save operation:
  ///            - `.didReload`: If the task was saved successfully.
  ///            - `.didReceiveError`: If there was an error during the save operation, sending the error.
  fileprivate func saveTaskEffect(_ task: Task) -> Effect<TaskList.Action> {
    return .run { send in
      let result = await taskListUseCase.saveTask(task)
      switch result {
      case .success(_):
        return await send(.didReload)
      case .failure(let error):
        return await send(.didReceiveError(error))
      }
    }
  }

  /// Deletes a task and sends an appropriate action based on the result.
  ///
  /// - Parameter task: The `Task` object that needs to be deleted.
  /// - Returns: An `Effect` that sends a `TaskList.Action` based on the result of the delete operation:
  ///            - `.didReload`: If the task was deleted successfully.
  ///            - `.didReceiveError`: If there was an error during the delete operation, sending the error.
  fileprivate func deleteTaskEffect(_ task: Task) -> Effect<TaskList.Action> {
    return .run { send in
      let result = await taskListUseCase.deleteTask(task)
      switch result {
      case .success(_):
        return await send(.didReload)
      case .failure(let error):
        return await send(.didReceiveError(error))
      }
    }
  }

  /// Deletes all tasks and sends an appropriate action based on the result.
  ///
  /// - Returns: An `Effect` that sends a `TaskList.Action` based on the result of the delete operation:
  ///            - `.didReload`: If all tasks were deleted successfully.
  ///            - `.didReceiveError`: If there was an error during the delete operation, sending the error.
  fileprivate func deleteAllTasksEffect() -> Effect<TaskList.Action> {
    return .run { send in
      let result = await taskListUseCase.deleteAllTasks()
      switch result {
      case .success(_):
        return await send(.didReload)
      case .failure(let error):
        return await send(.didReceiveError(error))
      }
    }
  }

  /// Loads the task list and sends an appropriate action based on the result.
  ///
  /// - Returns: An `Effect` that sends a `TaskList.Action` based on the result of the load operation:
  ///            - `.didReceiveTaskList`: If the task list was successfully fetched, sending the list.
  ///            - `.didReceiveError`: If there was an error during the fetch operation, sending the error.
  fileprivate func loadEffect() -> Effect<TaskList.Action> {
    return .run { send in
      let result = await taskListUseCase.fetchTaskList()
      switch result {
      case .success(let taskList):
        return await send(.didReceiveTaskList(taskList))
      case .failure(let error):
        return await send(.didReceiveError(error))
      }
    }
  }
}
