import ComposableArchitecture

extension DetailsReducer {
    
    // MARK: - UIAction
    enum UIAction: Equatable {
        case onAppear
        case onFavoriteButtonTapped
    }
    
    // MARK: - UIReducer
    @Reducer
    struct UIReducer: Sendable {
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            guard case let .ui(uiAction) = action else { return .none }
            
            switch uiAction {
            case .onAppear:
                return .merge(
                    [
                        .send(.data(.isInFavorites(state.repoModel))),
                        .send(.userRequest(.requestUserData(state.repoModel.id)))
                    ]
                )
                
            case .onFavoriteButtonTapped:
                state.isInFavorites.toggle()
                
                if state.isInFavorites {
                    return .send(.data(.addInFavorites(state.repoModel)))
                } else {
                    return .send(.data(.removeFromFavorites(state.repoModel)))
                }
            }
        }
    }
}
