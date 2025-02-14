import Foundation
import Combine

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol: AnyObject {
    func search(text: String, nextPage: String?) -> AnyPublisher<[RepoModel], Error>
    func user(userId: Int) -> AnyPublisher<UserResponce, Error>
    func cancelAllTasks() async
}

// MARK: - NetworkManager
final class NetworkManager: NetworkManagerProtocol {
    private let decoder = JSONDecoder()
    private var session = URLSession(configuration: .default)
    
    // MARK: - Protocol
    func cancelAllTasks() async {
        // cancels all tasks
        await session.allTasks.forEach { $0.cancel() }
    }
    
    func user(userId: Int) -> AnyPublisher<UserResponce, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            Task {
                do {
                    let data = try await self.requestUserData(with: userId)
                    
                    promise(.success(data))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func search(text: String, nextPage: String?) -> AnyPublisher<[RepoModel], Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            Task {
                do {
                    let data = try await self.requestSearchData(with: text, nextPage: nextPage)
                    
                    promise(.success(data))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func requestUserData(with userId: Int) async throws -> UserResponce {
        // cancels all tasks
        await cancelAllTasks()
        
        // make request
        let request = GithubAPI.user(userId: userId).request
        
        // receive data & responce
        let (data, _) = try await session.data(for: request)
        
        // decoding
        let model = try decoder.decode(UserResponce.self, from: data)
        
        return model
    }
    
    private func requestSearchData(with text: String, nextPage: String?) async throws -> [RepoModel] {
        // cancels all tasks
        await cancelAllTasks()
        
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
                print("HEADER HERE", linkHeader)
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
        
        return models
    }
}
