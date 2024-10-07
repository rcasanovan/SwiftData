import ComposableArchitecture
import Foundation

@Reducer
public struct TaskList {
  @ObservableState
  public struct State: Equatable {
    /// The current network state for the feature
    public var networkState: NetworkState<[Task], Task.Error>

    public init(
      networkState: NetworkState<[Task], Task.Error>
    ) {
      self.networkState = networkState
    }
  }

  public enum Action: Equatable {
    case didReceiveError(Task.Error)
    case didReceiveTaskList([Task])
    case didReload
    case didTapOnAddTask(String)
    case didTapOnDeleteAllTasks
    case didTapOnDeleteTask(Task)
    case onAppear
  }

  private let taskListUseCase: TaskListUseCase

  public init(taskListUseCase: TaskListUseCase) {
    self.taskListUseCase = taskListUseCase
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didReceiveError(_):
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
      }
    }
  }
}

extension TaskList {
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
