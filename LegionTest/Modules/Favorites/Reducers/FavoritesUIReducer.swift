import ComposableArchitecture

extension FavoritesReducer {
    
    // MARK: - UIAction
    enum UIAction: Equatable {
        case onAppear
        case onCellTapped(RepoModel)
    }
    
    // MARK: - UIReducer
    @Reducer
    struct UIReducer {
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            guard case let .ui(uiAction) = action else { return .none }
            
            switch uiAction {
            case .onAppear:
                return .send(.dataRequest(.requestReposFromStorage))
            case .onCellTapped(let model):
                return .send(.delegate(.moveToDetails(model)))
            }
        }
    }
}
