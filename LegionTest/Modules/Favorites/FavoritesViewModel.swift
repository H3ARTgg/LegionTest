import SwiftUI

// MARK: - FavoritesViewModelProtocol
protocol FavoritesViewModelProtocol: ObservableObject, AnyObject {
    var items: [RepoModel] { get }
    
    func getSavedRepos()
}

// MARK: - FavoritesViewModel
final class FavoritesViewModel: FavoritesViewModelProtocol {
    @Published var items: [RepoModel] = []
    
    private let navigation: NavigationManager
    private let dataManager: RealmManagerProtocol
    
    // MARK: - Init
    init(dataManager: RealmManagerProtocol, navigation: NavigationManager) {
        self.navigation = navigation
        self.dataManager = dataManager
    }
    
    // MARK: - Methods
    func getSavedRepos() {
        items = dataManager.getRepos()
    }
}

// MARK: - Collection Delegate
extension FavoritesViewModel: CollectionDelegate {
    func didDisplayCell(at index: Int) {
        return
    }
    
    func presentDetails(for model: RepoModel) {
        navigation.navigate(to: .details(model: model))
    }
}
