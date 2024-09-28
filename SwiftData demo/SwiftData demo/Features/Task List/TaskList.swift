import ComposableArchitecture
import Foundation

@Reducer
public struct TaskList {
    //__ The basic state. Feel free to change this if needed.
    @ObservableState
    public struct State: Equatable {
        public var title = ""
    }

    //__ The basic actions. Feel free to change this if needed.
    public enum Action: Equatable {
        case didReceiveTitle(String)
        case onAppear
    }
    
    //__ You can add more properties if needed.
    //__ e.g: private let useCase: UseCase
    //__ If this is the case, you'll need to implement the init()
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didReceiveTitle(let title):
                state.title = title
                return .none
            case .onAppear:
                return self.loadEffect()
            }
        }
    }
}

extension TaskList {
    //__ A default load effect. Feel free to change this if needed.
    //__ You can include API calls, database calls or any use case call if needed.
    fileprivate func loadEffect() -> Effect<TaskList.Action> {
        return .run { send in
            return await send(.didReceiveTitle("test title"))
        }
    }
}
