import ComposableArchitecture
import SwiftUI

struct TaskListView: View {
  @State private var showAddTaskPopup = false
  @State private var inputText = ""
  @StateObject private var keyboardResponder = KeyboardResponder()

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
        deleteAllOnTap: {},
        addNewTaskOnTap: { showAddTaskPopup = true }
      )
      .background(Color.white)

      if showAddTaskPopup {
        VStack {
          Spacer()  // Push the popup to the bottom

          AddTaskView(
            showPopup: $showAddTaskPopup,
            inputText: $inputText,
            onAccept: {
              store.send(.didTapOnAddTask(inputText))
              inputText = ""
            }
          )
          .frame(height: 190)
          .background(Color.white)
          .transition(.move(edge: .bottom))
          .animation(.spring(), value: showAddTaskPopup)
        }
        .edgesIgnoringSafeArea(.bottom)
        .padding(.bottom, 1)
      }
    }
    .background(.white)
  }

  //__ This is the body for the view
  var body: some View {
    content
      .onAppear {
        store.send(.onAppear)
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
