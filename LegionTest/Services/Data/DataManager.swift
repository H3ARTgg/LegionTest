import Sharing
import Dependencies

// MARK: - SharedKey Extension
extension SharedKey
where Self == FileStorageKey<Array<RepoModel>> {
  static var repos: Self {
      fileStorage(.documentsDirectory.appending(component: "repos.json"))
  }
}

// MARK: - DataRepoKey
enum DataRepoKey: DependencyKey {
    static let liveValue: any DataManagerProtocol = DataManager()
}

// MARK: - DependencyValues
extension DependencyValues: Sendable {
    var dataRepo: any DataManagerProtocol {
        get { self[DataRepoKey.self] }
        set { self[DataRepoKey.self] = newValue }
    }
}

// MARK: - DataManagerProtocol
protocol DataManagerProtocol: AnyObject, Sendable {
    func writeRepo(_ repo: RepoModel)
    func removeRepo(_ repo: RepoModel)
    func getRepos() -> [RepoModel]
    func isRepoContains(_ repo: RepoModel) -> Bool
}

// MARK: - DataManager
final class DataManager: DataManagerProtocol {
    @Shared(.repos) var repos: [RepoModel] = []
    
    func writeRepo(_ repo: RepoModel) {
        $repos.withLock {
            $0.append(repo)
        }
    }
    
    func removeRepo(_ repo: RepoModel) {
        $repos.withLock { repos in
            repos.removeAll { $0 == repo }
        }
    }
    
    func getRepos() -> [RepoModel] {
        repos
    }
    
    func isRepoContains(_ repo: RepoModel) -> Bool {
        repos.contains(repo)
    }
}
