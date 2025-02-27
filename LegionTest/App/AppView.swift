import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Perception.Bindable var store: StoreOf<AppReducer>
    
    // MARK: - Body
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                WithPerceptionTracking {
                    TabView {
                        // Repos List Screen
                        ListView(store: store.scope(state: \.list, action: \.list))
                            .tabItem {
                                Label {
                                    Text("Repos")
                                        .font(.system(size: 10, weight: .bold))
                                } icon: {
                                    Image(.folderTab)
                                }
                            }
                            .foregroundStyle(store.selectedTab == .list ? Color.white : Color.tWhite)
                            .tag(AppReducer.Tab.list)
                            .navigationTitle("Repos")
                            .toolbar(.hidden)
                        
                        // Favorites Screen
                        FavoritesView(store: store.scope(state: \.favorites, action: \.favorites))
                            .tabItem {
                                Label {
                                    Text("Favorites")
                                        .font(.system(size: 10, weight: .bold))
                                } icon: {
                                    Image(.favoriteTab)
                                }
                            }
                            .foregroundStyle(store.selectedTab == .favorites ? Color.white : Color.tWhite)
                            .tag(AppReducer.Tab.favorites)
                            .navigationTitle("Favorites")
                            .toolbar(.hidden)
                    }
                } /// WithPerceptionTracking
            } destination: { store in
                switch store.case {
                case let .details(store):
                    DetailsView(store: store)
                }
            }
            .tint(.white)
        }
    }
}
