import SwiftUI
import ComposableArchitecture

@main
struct LegionTestApp: App {
    static let networkManager = NetworkManager()
    static let dataManager = DataManager()
    static let store = Store(initialState: AppReducer.State(list: ListReducer.State(), favorites: FavoritesReducer.State())) {
        AppReducer()
    } withDependencies: {
        $0.searchRepo = networkManager
        $0.dataRepo = dataManager
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: LegionTestApp.store)
        }
    }
}
