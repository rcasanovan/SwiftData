import ComposableArchitecture
import Foundation

@Reducer
public struct TaskList {
  @ObservableState
  public struct State: Equatable {
    public var tasks: [Task] = []
  }

  public enum Action: Equatable {
    case didReceiveError(Task.Error)
    case didReceiveTaskList([Task])
    case didReload
    case didTapOnAddTask(String)
    case didTapOnDeleteAllTasks
    case onAppear
  }

  private let taskListUseCase: TaskListUseCase

  public init(taskListUseCase: TaskListUseCase) {
    self.taskListUseCase = taskListUseCase
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didReceiveError(let error):
        return .none
      case .didReceiveTaskList(let tasks):
        state.tasks = tasks
        return .none
      case .didReload:
        return self.loadEffect()
      case .didTapOnAddTask(let title):
        return .merge(
          self.saveTaskEffect(Task(title: title)),
          self.loadEffect()
        )
      case .didTapOnDeleteAllTasks:
        return .merge(
          self.deleteAllTasksEffect(),
          self.loadEffect()
        )
        return .none
      case .onAppear:
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
      case .success(let status):
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
      case .success(let status):
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