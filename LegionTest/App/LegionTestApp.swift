import SwiftUI

@main
struct LegionTestApp: App {
    @StateObject private var navigationManager = NavigationManager()
    @State private var selectedTab: Int = 0
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationManager.path) {
                TabView {
                    // Repos List Screen
                    navigationManager.createListModule()
                        .tabItem {
                            Label {
                                Text("Repos")
                                    .font(.system(size: 10, weight: .bold))
                            } icon: {
                                Image(.folderTab)
                            }
                        }
                        .foregroundStyle(selectedTab == 0 ? Color.white : Color.tWhite)
                        .tag(0)
                        .navigationTitle("Repos")
                        .toolbar(.hidden)
                    
                    // Favorites Screen
                    navigationManager.createFavoritesModule()
                        .tabItem {
                            Label {
                                Text("Favorites")
                                    .font(.system(size: 10, weight: .bold))
                            } icon: {
                                Image(.favoriteTab)
                            }
                        }
                        .foregroundStyle(selectedTab == 1 ? Color.white : Color.tWhite)
                        .tag(1)
                        .navigationTitle("Favorites")
                        .toolbar(.hidden)
                }
                .navigationDestination(for: Destinations.self) { value in
                    switch value {
                    case .details(let model):
                        navigationManager.createDetailsModule(for: model)
                    }
                }
            }
            .tint(.white)
        }
    }
}
