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
            Text(store.title)
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
                TaskList()
            }
        )
    }
}

#if DEBUG

// MARK: Previews

#Preview {
    let store: StoreOf<TaskList> =  .init(
        initialState: TaskList.State()
    ) {
        TaskList()
    }
    return TaskListView(store: store)
}

#endif
