import ComposableArchitecture

extension DetailsReducer {
    
    // MARK: - RequestAction
    enum RequestAction {
        case requestUserData(Int)
        case onSuccess(UserResponce)
        case onError
    }
    
    // MARK: - RequestReducer
    @Reducer
    struct RequestReducer: Sendable {
        @Dependency(\.searchRepo) var searchRepo
        
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            guard case let .userRequest(requestAction) = action else { return .none }
            
            switch requestAction {
            case .requestUserData(let userId):
                return .run { send in
                    let result = await searchRepo.user(userId: userId)
                    switch result {
                    case .success(let item):
                        await send(.userRequest(.onSuccess(item)))
                    case .failure:
                        await send(.userRequest(.onError))
                    }
                }
                
            case _:
                return .none
            }
        }
    }
}
