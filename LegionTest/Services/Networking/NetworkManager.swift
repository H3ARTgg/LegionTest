import Foundation
import Combine
import Dependencies

enum SearchRepoKey: DependencyKey, Sendable {
    static let liveValue: any NetworkManagerProtocol = NetworkManager()
}

extension DependencyValues: Sendable {
    var searchRepo: any NetworkManagerProtocol {
        get { self[SearchRepoKey.self] }
        set { self[SearchRepoKey.self] = newValue }
    }
}

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol: AnyObject, Sendable {
    func search(text: String, nextPage: String?) async -> Result<[RepoModel], Error>
    func user(userId: Int) async -> Result<UserResponce, Error>
    func cancelAllTasks() async
}

// MARK: - NetworkManager
final class NetworkManager: NetworkManagerProtocol {
    private let decoder = JSONDecoder()
    private let session = URLSession(configuration: .default)
    
    // MARK: - Protocol
    func cancelAllTasks() async {
        // cancels all tasks
        await session.allTasks.forEach { $0.cancel() }
    }
    
    func user(userId: Int) async -> Result<UserResponce, Error> {
        // cancels all tasks
        await cancelAllTasks()
        
        // make request
        let request = GithubAPI.user(userId: userId).request
        
        do {
            // receive data & responce
            let (data, _) = try await session.data(for: request)
            
            // decoding
            let model = try decoder.decode(UserResponce.self, from: data)
            
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
    
    func search(text: String, nextPage: String?) async -> Result<[RepoModel], any Error> {
        // cancels all tasks
        await cancelAllTasks()
        
        do {
            // make request
            let request = GithubAPI.search(search: text, nextPage: nextPage).request
            
            // receive data & responce
            let (data, responce) = try await session.data(for: request)
            
            // finding and taking "next" and "last" urls
            guard let httpResponse = responce as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            var nextUrl: String? = nil
            var lastUrl: String? = nil
            let nextPattern = "(?<=<)(https?://[\\S]+)(?=>; rel=\"next\")"
            let lastParrern = "(?<=<)(https?://[\\S]+)(?=>; rel=\"last\")"
            
            if let linkHeader = httpResponse.allHeaderFields["Link"] as? String {
                if linkHeader.contains("rel=\"next\"") {
                    let regex = try? NSRegularExpression(pattern: nextPattern, options: .caseInsensitive)
                    
                    if let match = regex?.firstMatch(in: linkHeader, options: [], range: NSRange(linkHeader.startIndex..., in: linkHeader)) {
                        let nextLink = (linkHeader as NSString).substring(with: match.range(at: 1))
                        nextUrl = nextLink
                    }
                }
                
                if linkHeader.contains("rel=\"last\"") {
                    let regex = try? NSRegularExpression(pattern: lastParrern, options: .caseInsensitive)
                    
                    if let match = regex?.firstMatch(in: linkHeader, options: [], range: NSRange(linkHeader.startIndex..., in: linkHeader)) {
                        let lastLink = (linkHeader as NSString).substring(with: match.range(at: 1))
                        lastUrl = lastLink
                    }
                }
            }
            
            // decoding
            let decodedData = try decoder.decode(SearchResponce.self, from: data)
            
            // converting
            let models = decodedData.items.map {
                RepoModel(nextUrl: nextUrl, lastUrl: lastUrl, id: $0.id, name: $0.name, fullName: $0.fullName, owner: $0.owner, description: $0.description)
            }
            
            return .success(models)
        } catch {
            return .failure(error)
        }
    }
}
