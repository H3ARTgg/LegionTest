import ComposableArchitecture

@Reducer
struct FavoritesReducer {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var items: [RepoModel] = []
        var screenState: ScreenState = .empty
        let notificationText: String = "Nothing found :("
    }
    
    // MARK: - ScreenState
    enum ScreenState {
        case empty
        case favorites
    }
    
    // MARK: - Action
    enum Action {
        case ui(UIAction)
        case dataRequest(DataAction)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToDetails(RepoModel)
        }
    }
    
    // MARK: - Body
    var body: some ReducerOf<Self> {
        MainReducer()
        UIReducer()
        DataReducer()
    }
}
