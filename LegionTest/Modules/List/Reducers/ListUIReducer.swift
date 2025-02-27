import ComposableArchitecture

extension ListReducer {
    
    // MARK: - UIAction
    enum UIAction: Equatable {
        case onSearchButtonTapped
        case onScrollToBottomSearch(Int)
        case onCellTapped(RepoModel)
    }
    
    // MARK: - UIReducer
    @Reducer
    struct UIReducer {
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            guard case let .ui(uiAction) = action else { return .none }
            
            switch uiAction {
            case .onSearchButtonTapped:
                if !state.searchedText.isEmpty {
                    state.screenState = .loading
                    state.notificationText = ""
                    return .send(.searchRequest(.startSearchRequest(state.searchedText)))
                }
                return .none
                
            case .onScrollToBottomSearch(let index):
                guard index == state.items.count - 1 else { return .none }
                guard state.items.indices.contains(0) else { return .none }
                state.screenState = .loading
                return .send(.searchRequest(.continueSearchRequest(state.items[0].nextUrl)))
                
            case .onCellTapped(let model):
                return .send(.delegate(.moveToDetails(model)))
            }
        }
    }
}
