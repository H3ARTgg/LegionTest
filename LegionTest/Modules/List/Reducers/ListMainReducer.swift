import ComposableArchitecture

extension ListReducer {
    
    // MARK: - MainReducer
    @Reducer
    struct MainReducer: Sendable {
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            switch action {
            case .searchRequest(.onStartSuccess(let items)):
                state.items = items
                state.screenState = .initial
                return .none
                
            case .searchRequest(.onContinueSuccess(let items)):
                state.items.append(contentsOf: items)
                state.screenState = .initial
                return .none
                
            case .searchRequest(.onError((let isContinue))):
                if isContinue {
                    state.notificationText = ""
                } else {
                    state.notificationText = "Nothing found :("
                }
                state.screenState = .initial
                return .none
                
            case .binding(\.searchedText):
                if state.searchedText.isEmpty {
                    state.items = []
                    state.notificationText = "Type something to search in repositories"
                }
                return .none
                
            case .delegate(_):
                return .none
                
            case .binding(_):
                return .none
            case _:
                return .none
            }
        }
    }
}
