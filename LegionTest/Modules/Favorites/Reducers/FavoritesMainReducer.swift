import ComposableArchitecture

extension FavoritesReducer {
    
    // MARK: - MainReducer
    @Reducer
    struct MainReducer {
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            switch action {
            case .dataRequest(.onRecieveFavorites(let items)):
                state.items = items
                state.screenState = items.isEmpty ? .empty : .favorites
                return .none
            case _:
                return .none
            }
        }
    }
}
