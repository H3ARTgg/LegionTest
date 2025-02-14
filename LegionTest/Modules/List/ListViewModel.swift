import Foundation
import Combine

// MARK: - ListViewModelProtocol
protocol ListViewModelProtocol: AnyObject, ObservableObject {
    var items: [RepoModel] { get }
    var isLoading: Bool { get }
    
    func search(with text: String) async
}

// MARK: - ListViewModel
final class ListViewModel: ListViewModelProtocol {
    @Published var items: [RepoModel] = []
    @Published var isLoading: Bool = false
    
    private var nextPage: String?
    private var cancellebles: Set<AnyCancellable> = []
    private var currentText: String = ""
    private var isLastPageLoaded: Bool = false
    
    private let navigation: NavigationManager
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol, navigation: NavigationManager) {
        self.networkManager = networkManager
        self.navigation = navigation
    }
    
    // MARK: - Methods
    func search(with text: String) {
        // if text is empty, then leave
        guard !text.isEmpty else {
            Task {
                await networkManager.cancelAllTasks()
            }
            items = []
            currentText = ""
            isLoading = false
            return
        }
        
        let oldText = currentText
        currentText = text
        
        if oldText != currentText {
            isLastPageLoaded = false
        }
        
        // if already loaded last page
        guard !isLastPageLoaded else { return }
        
        // reseting nextPage if typing new text to search
        if let nextPage {
            if !nextPage.contains("?q=" + text) {
                self.nextPage = nil
            }
        }
        
        // start loading
        isLoading = true
        
        networkManager.search(text: text, nextPage: nextPage)
            .throttle(for: 0.2, scheduler: RunLoop.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                // stop loading
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.items = []
                    print(error)
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                
                switch data.isEmpty {
                case false:
                    self.nextPage = data[0].nextUrl
                    
                    // if last page aldready loaded
                    if data[0].nextUrl == nil {
                        self.isLastPageLoaded = true
                    }
                case true:
                    self.nextPage = nil
                }
                
                if oldText == currentText {
                    // if downloading next 30
                    items.append(contentsOf: data)
                } else {
                    // if new search request
                    items = data
                }
                
                print(data.count)
            }
            .store(in: &cancellebles)
    }
}

// MARK: - Collection Delegate
extension ListViewModel: CollectionDelegate {
    func didDisplayCell(at index: Int) {
        if index == items.count - 1 {
            search(with: currentText)
        }
    }
    
    func presentDetails(for model: RepoModel) {
        navigation.navigate(to: .details(model: model))
    }
}
