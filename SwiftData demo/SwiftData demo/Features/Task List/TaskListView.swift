import ComposableArchitecture
import SwiftUI

struct TaskListView: View {
  @State private var inputText = ""

  private var store: StoreOf<TaskList>

  public init(store: StoreOf<TaskList>) {
    self.store = store
  }

  @ViewBuilder
  //__ This content view
  private var content: some View {
    switch store.networkState {
    case .loading:
      loadingState()
    case .completed(.success(let tasks)):
      successState(with: tasks)
    case .completed(.failure(let error)):
      failureState(with: error.localizedDescription)
    case .ready:
      Color.clear
    }
  }

  func statusBarHeight() -> CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      return windowScene.windows.first?.safeAreaInsets.top ?? 0
    }
    return 0
  }

  //__ This is the body for the view
  var body: some View {
    WithViewStore(self.store, observe: \.self) { viewStore in
      content
        .onAppear {
          viewStore.send(.onAppear)
        }
        .alert(
          "Enter a new task title",
          isPresented: viewStore.binding(
            get: \.showAddTaskAlert,
            send: TaskList.Action.setShowAddTaskAlert
          )
        ) {
          TextField("Task", text: $inputText)
          Button(action: {
            inputText = ""
            viewStore.send(.setShowAddTaskAlert(false))
          }) {
            Text("Cancel")
          }
          Button(action: {
            viewStore.send(.didTapOnAddTask(inputText))
            viewStore.send(.setShowAddTaskAlert(false))
            inputText = ""
          }) {
            Text("Create")
          }
        }
        .alert(
          "Do you want to delete all the tasks?",
          isPresented: viewStore.binding(
            get: \.showDeleteAllTasksAlert,
            send: TaskList.Action.setShowDeleteAllTasksAlert
          )
        ) {
          Button(action: {
            viewStore.send(.setShowDeleteAllTasksAlert(false))
          }) {
            Text("Cancel")
          }
          Button(action: {
            viewStore.send(.didTapOnDeleteAllTasks)
            viewStore.send(.setShowDeleteAllTasksAlert(false))
          }) {
            Text("Delete all")
          }
        }
    }
  }
}

// MARK: - States
extension TaskListView {
  fileprivate func loadingState() -> some View {
    ZStack(alignment: .top) {
      List {
        Spacer().frame(height: 36)
        ForEach(0..<15, id: \.self) { _ in
          TaskView(taskTitle: "Placeholder title")
            .listRowBackground(Color.white)
            .redacted(reason: .placeholder)
        }
        .listRowSeparator(.visible)
      }
      .listStyle(PlainListStyle())
      .background(Color.white)
      .scrollContentBackground(.hidden)

      // Sticky Header
      HeaderView(
        isDeleteAllDisabled: true,
        deleteAllOnTap: {
          store.send(.setShowDeleteAllTasksAlert(true))
        },
        addNewTaskOnTap: {
          store.send(.setShowAddTaskAlert(true))
        }
      )
      .background(.white)
      .disabled(true)
    }
    .background(.white)
  }

  fileprivate func successState(with tasks: [Task]) -> some View {
    ZStack(alignment: .top) {
      List {
        Spacer().frame(height: 36)
        ForEach(tasks, id: \.self) { task in
          TaskView(taskTitle: task.title)
            .swipeActions {
              Button(role: .destructive) {
                store.send(.didTapOnDeleteTask(task))
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
            .listRowBackground(Color.white)
        }
        .listRowSeparator(.visible)
      }
      .listStyle(PlainListStyle())
      .background(Color.white)
      .scrollContentBackground(.hidden)

      // Sticky Header
      HeaderView(
        isDeleteAllDisabled: tasks.isEmpty,
        deleteAllOnTap: {
          store.send(.setShowDeleteAllTasksAlert(true))
        },
        addNewTaskOnTap: {
          store.send(.setShowAddTaskAlert(true))
        }
      )
      .background(.white)
    }
    .background(.white)
  }

  fileprivate func failureState(with error: String) -> some View {
    Text(error)
      .foregroundColor(.black)
  }
}

extension TaskListView {
  fileprivate func separator() -> some View {
    Divider()
      .frame(height: 1)
      .background(.gray)
      .padding(.leading)
  }
}

// MARK: - Factory

extension TaskListView {
  static func make() -> Self {
    TaskListView(
      store: .init(
        initialState: .init(networkState: .ready)
      ) {
        TaskList(
          taskListUseCase: TaskListUseCaseImpl(databaseManager: DatabaseManagerImp.live)
        )
      }
    )
  }
}

#if DEBUG

// MARK: Previews

/// Provides a set of previews for `TaskListView` in different predefined states.
///
/// This struct encapsulates the `TaskListView` within a `Preview` view that takes a `StoreOf<TaskList>`
/// to display the task list UI based on different initial states for testing.
///
/// # Preview Definitions:
/// - `success`: Displays `TaskListView` in a state where tasks were successfully loaded.
/// - `failure`: Displays `TaskListView` in a state where loading tasks failed.
/// - `loading`: Displays `TaskListView` in a loading state where tasks are being fetched.
/// - `showAddTaskAlert`: Displays `TaskListView` with an alert for adding a new task.
/// - `showDeleteAllTasksAlert`: Displays `TaskListView` with an alert for deleting all tasks.
struct TaskListView_Preview {
  struct Preview: View {
    var store: StoreOf<TaskList>
    var body: some View {
      TaskListView(store: store)
    }
  }
}

#Preview {
  let store: StoreOf<TaskList> = .init(
    initialState: .success
  ) {
    TaskList(
      taskListUseCase: TaskListUseCaseSuccessMock()
    )
  }
  return TaskListView(store: store)
}

#Preview {
  let store: StoreOf<TaskList> = .init(
    initialState: .failure
  ) {
    TaskList(
      taskListUseCase: TaskListUseCaseSuccessMock()
    )
  }
  return TaskListView(store: store)
}

#Preview {
  let store: StoreOf<TaskList> = .init(
    initialState: .loading
  ) {
    TaskList(
      taskListUseCase: TaskListUseCaseSuccessMock()
    )
  }
  return TaskListView(store: store)
}

#Preview {
  let store: StoreOf<TaskList> = .init(
    initialState: .showAddTaskAlert
  ) {
    TaskList(
      taskListUseCase: TaskListUseCaseSuccessMock()
    )
  }
  return TaskListView(store: store)
}

#Preview {
  let store: StoreOf<TaskList> = .init(
    initialState: .showDeleteAllTasksAlert
  ) {
    TaskList(
      taskListUseCase: TaskListUseCaseSuccessMock()
    )
  }
  return TaskListView(store: store)
}

#endif
