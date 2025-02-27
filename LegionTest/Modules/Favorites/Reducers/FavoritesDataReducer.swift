import ComposableArchitecture

extension FavoritesReducer {
    
    // MARK: - DataAction
    enum DataAction: Equatable {
        case requestReposFromStorage
        case onRecieveFavorites([RepoModel])
    }
    
    // MARK: - DataReducer
    @Reducer
    struct DataReducer {
        @Dependency(\.dataRepo) var dataRepo
        
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            guard case let .dataRequest(dataAction) = action else { return .none }
            
            switch dataAction {
            case .requestReposFromStorage:
                let items = dataRepo.getRepos()
                return .send(.dataRequest(.onRecieveFavorites(items)))
                
            case _:
                return .none
            }
        }
    }
}
