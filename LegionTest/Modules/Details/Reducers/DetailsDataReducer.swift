import ComposableArchitecture

extension DetailsReducer {
    
    // MARK: - DetailsDataReducerAction
    enum DataAction: Equatable {
        case isInFavorites(RepoModel)
        case addInFavorites(RepoModel)
        case removeFromFavorites(RepoModel)
    }
    
    // MARK: - DataReducer
    @Reducer
    struct DataReducer {
        @Dependency(\.dataRepo) var dataRepo
        
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            guard case let .data(dataAction) = action else { return .none }
            
            switch dataAction {
            case .isInFavorites(let model):
                state.isInFavorites = dataRepo.isRepoContains(model)
                return .none
                
            case .addInFavorites(let model):
                dataRepo.writeRepo(model)
                return .none
                
            case .removeFromFavorites(let model):
                dataRepo.removeRepo(model)
                return .none
            }
        }
    }
}
