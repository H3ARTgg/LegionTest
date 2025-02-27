import ComposableArchitecture

extension ListReducer {
    
    // MARK: - RequestAction
    enum RequestAction: Equatable {
        case startSearchRequest(String)
        case continueSearchRequest(String?)
        case onStartSuccess([RepoModel])
        case onContinueSuccess([RepoModel])
        case onError(isContinue: Bool)
    }
    
    // MARK: - RequestReducer
    @Reducer
    struct RequestReducer: Sendable {
        @Dependency(\.searchRepo) var searchRepo
        
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            guard case let .searchRequest(searchAction) = action else { return .none }
            
            switch searchAction {
            case .startSearchRequest(let text):
                return .run { send in
                    let result = await searchRepo.search(text: text, nextPage: nil)
                    switch result {
                    case .success(let items):
                        await send(.searchRequest(.onStartSuccess(items)))
                    case .failure:
                        await send(.searchRequest(.onError(isContinue: false)))
                    }
                }
                
            case .continueSearchRequest(let nextUrl):
                return .run { send in
                    let result = await searchRepo.search(text: "", nextPage: nextUrl)
                    switch result {
                    case .success(let items):
                        await send(.searchRequest(.onContinueSuccess(items)))
                    case .failure:
                        await send(.searchRequest(.onError(isContinue: true)))
                    }
                }
                
            case _:
                return .none
            }
        }
    }
}


   
