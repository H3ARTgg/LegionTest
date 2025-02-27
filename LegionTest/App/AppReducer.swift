import ComposableArchitecture
import SwiftUI

@Reducer
struct AppReducer {
    // MARK: - Tab
    public enum Tab: Hashable, Equatable, Sendable, Identifiable {
        case list
        case favorites
        
        public var id: Self { self }
    }
    
    // MARK: - AppPath
    @Reducer
    enum AppPath {
        case details(DetailsReducer)
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        var selectedTab: Tab?
        var list: ListReducer.State
        var favorites: FavoritesReducer.State
        var path = StackState<AppPath.State>()
    }
    
    // MARK: - Action
    enum Action: ViewAction {
        @CasePathable
        public enum View {
            case tabSelected(Tab?)
        }
        
        case view(View)
        case list(ListReducer.Action)
        case favorites(FavoritesReducer.Action)
        case path(StackActionOf<AppPath>)
    }
    
    // MARK: - Body
    public var body: some ReducerOf<Self> {
        Scope(state: \.list, action: \.list) {
            ListReducer()
        }
        
        Scope(state: \.favorites, action: \.favorites) {
            FavoritesReducer()
        }
        
        Reduce { state, action in
            switch action {
            case let .view(.tabSelected(tab)):
                state.selectedTab = tab
                return .none
            case .list(.delegate(.moveToDetails(let model))):
                state.path.append(.details(DetailsReducer.State(repoModel: model)))
                return .none
                
            case .favorites(.delegate(.moveToDetails(let model))):
                state.path.append(.details(DetailsReducer.State(repoModel: model)))
                return .none
                
            case .list:
                return .none
            case .favorites:
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
