import ComposableArchitecture

@Reducer
struct ListReducer: Sendable {
    
    // MARK: - State
    @ObservableState
    struct State {
        var items: [RepoModel] = []
        var screenState: ScreenState = .initial
        var searchedText: String = ""
        var notificationText: String = "Type something to search in repositories"
    }
    
    // MARK: - ScreenState
    enum ScreenState {
        case initial
        case loading
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case ui(UIAction)
        case searchRequest(RequestAction)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToDetails(RepoModel)
        }
    }
    
    // MARK: - Body
    var body: some ReducerOf<Self> {
        BindingReducer()
        MainReducer()
        UIReducer()
        RequestReducer()
    }
}
