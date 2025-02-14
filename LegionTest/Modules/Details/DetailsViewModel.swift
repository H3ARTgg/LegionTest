import SwiftUI
import Combine

// MARK: - DetailsViewModelProtocol
protocol DetailsViewModelProtocol: ObservableObject, AnyObject {
    var userData: UserModel? { get }
    var isLoading: Bool { get }
    var isInFavorites: Bool { get }
    
    func requestUserData()
    func favorite(isChanging: Bool)
}

// MARK: - DetailsViewModel
final class DetailsViewModel: DetailsViewModelProtocol {
    @Published var userData: UserModel?
    @Published var isLoading: Bool = false
    @Published var isInFavorites: Bool = false
    
    private let repoModel: RepoModel
    private let navigation: NavigationManager
    private let networkManager: NetworkManagerProtocol
    private let dataManager: RealmManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(model: RepoModel, networkManager: NetworkManagerProtocol, dataManager: RealmManagerProtocol, navigation: NavigationManager) {
        self.networkManager = networkManager
        self.repoModel = model
        self.navigation = navigation
        self.dataManager = dataManager
    }
    
    // MARK: - Methods
    func favorite(isChanging: Bool = false) {
        if !isChanging {
            isInFavorites = dataManager.isRepoContains(repoModel)
            return
        }
        
        isInFavorites.toggle()
        isInFavorites ? dataManager.writeRepo(repoModel) : dataManager.removeRepo(repoModel)
    }
    
    func requestUserData() {
        isLoading = true
        networkManager.user(userId: repoModel.owner.id)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                guard let self else { return }
                
                self.userData = UserModel(
                    id: $0.id, name: $0.name ?? $0.login,
                    email: $0.email,
                    repoName: repoModel.fullName,
                    repoDescription: repoModel.description ?? "descr"
                )
            }
            .store(in: &cancellables)
    }
}
