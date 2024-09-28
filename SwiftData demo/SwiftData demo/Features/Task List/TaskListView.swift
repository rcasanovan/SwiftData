import ComposableArchitecture
import SwiftUI

struct TaskListView: View {
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
          Spacer().frame(height: 75)

          ForEach(store.tasks, id: \.self) { task in
            Text(task.title)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .frame(height: 140)
          }
        }
      }
    }
    .background(.black)
  }

  //__ This is the body for the view
  var body: some View {
    content
      .onAppear {
        store.send(.onAppear)
      }
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
