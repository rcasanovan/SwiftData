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
    ZStack(alignment: .top) {
      // Scrollable content
      ScrollView {
        VStack(spacing: 0) {
          Spacer().frame(height: 60)

          ForEach(store.tasks, id: \.self) { task in
            TaskView(taskTitle: task.title)
            separator()
          }
        }
      }

      // Sticky Header
      HeaderView(
        deleteAllOnTap: { showDeleteAllTasksAlert = true },
        addNewTaskOnTap: { showAddTaskAlert = true }
      )
      .background(Color.white)
    }
    .background(.white)
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
        initialState: TaskList.State()
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

#Preview {
  let store: StoreOf<TaskList> = .init(
    initialState: TaskList.State()
  ) {
    TaskList(
      taskListUseCase: TaskListUseCaseSuccessMock()
    )
  }
  return TaskListView(store: store)
}

#endif
