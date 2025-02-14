import SwiftUI

// MARK: - Destinations
enum Destinations: Hashable {
    case details(model: RepoModel)
}

// MARK: - NavigationManager
final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    private var viewModels: [AnyObject] = []
    private let networkManager = NetworkManager()
    private let dataManager = RealmManager()
    
    // MARK: - Navigation
    func navigate(to destination: Destinations) {
        path.append(destination)
    }
    
    func goBack() {
        viewModels.removeLast()
        path.removeLast()
    }
    
    // MARK: - Modules Creating
    func createListModule() -> ListView<ListViewModel> {
        let viewModel = ListViewModel(networkManager: networkManager, navigation: self)
        let view = ListView(viewModel: viewModel)
        viewModels.append(viewModel)
        return view
    }
    
    func createFavoritesModule() -> FavoritesView<FavoritesViewModel> {
        let viewModel = FavoritesViewModel(dataManager: dataManager, navigation: self)
        let view = FavoritesView(viewModel: viewModel)
        viewModels.append(viewModel)
        return view
    }
    
    func createDetailsModule(for model: RepoModel) -> DetailsView<DetailsViewModel> {
        let viewModel = DetailsViewModel(model: model, networkManager: networkManager, dataManager: dataManager, navigation: self)
        let view = DetailsView(viewModel: viewModel)
        viewModels.append(viewModel)
        return view
    }
}
