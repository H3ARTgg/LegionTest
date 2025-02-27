import ComposableArchitecture

@Reducer
struct DetailsReducer: Sendable {
    
    // MARK: - State
    @ObservableState
    struct State {
        var userData: UserModel?
        var screenState: ScreenState = .loading
        var isInFavorites: Bool = false
        let repoModel: RepoModel
    }
    
    // MARK: - ScreenState
    enum ScreenState {
        case loading
        case success
    }
    
    // MARK: - Action
    enum Action {
        case ui(UIAction)
        case userRequest(RequestAction)
        case data(DataAction)
    }
    
    // MARK: - Body
    var body: some ReducerOf<Self> {
        MainReducer()
        UIReducer()
        DataReducer()
        RequestReducer()
    }
}
