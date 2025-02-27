import ComposableArchitecture

extension DetailsReducer {
    
    // MARK: - MainReducer
    @Reducer
    struct MainReducer {
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            switch action {
            case .userRequest(.onSuccess(let model)):
                state.userData = UserModel(
                    id: model.id, name: model.name ?? model.login,
                    email: model.email,
                    repoName: state.repoModel.fullName,
                    repoDescription: state.repoModel.description
                )
                state.screenState = .success
                return .none
                
            case .userRequest(.onError):
                state.screenState = .success
                return .none
                
            case _:
                return .none
            }
        }
    }
}
