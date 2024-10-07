import ComposableArchitecture
import SwiftUI

struct TaskListView: View {
  @State private var showAddTaskAlert: Bool = false
  @State private var showDeleteAllTasksAlert: Bool = false
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
      EmptyView()
    case .completed(.success(let tasks)):
      success(with: tasks)
    case .completed(.failure(let error)):
      EmptyView()
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
    content
      .onAppear {
        store.send(.onAppear)
      }
      .alert("Enter a new task title", isPresented: $showAddTaskAlert) {
        TextField("Task", text: $inputText)
        Button(action: {
          inputText = ""
          showAddTaskAlert = false
        }) {
          Text("Cancel")
        }
        Button(action: {
          store.send(.didTapOnAddTask(inputText))
          showAddTaskAlert = false
          inputText = ""
        }) {
          Text("Create")
        }
        .disabled(inputText.isEmpty)
      }
      .alert("Do you want to delete all the tasks?", isPresented: $showDeleteAllTasksAlert) {
        Button(action: {
          showDeleteAllTasksAlert = false
        }) {
          Text("Cancel")
        }
        Button(action: {
          store.send(.didTapOnDeleteAllTasks)
          showDeleteAllTasksAlert = false
        }) {
          Text("Delete all")
        }
      }
  }
}

// MARK: - States & helpers
extension TaskListView {
  fileprivate func success(with tasks: [Task]) -> some View {
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
        deleteAllOnTap: { showDeleteAllTasksAlert = true },
        addNewTaskOnTap: { showAddTaskAlert = true }
      )
      .background(.white)
    }
    .background(.white)
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

#endif
