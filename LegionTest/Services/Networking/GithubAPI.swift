import Foundation

let bearerToken = ""

enum GithubAPI {
    case search(search: String, nextPage: String?)
    case user(userId: Int)
}

extension GithubAPI {
    var request: URLRequest {
        var url = URL(string: baseURL + path)!
        
        if case .search(_, let nextPage) = self {
            if let nextPage {
                url = URL(string: nextPage)!
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    var baseURL: String {
        return "https://api.github.com"
    }
    
    var path: String {
        switch self {
        case .search(let text, _):
            return "/search/repositories" + "?q=\(text)"
        case .user(let userId):
            return "/user/\(userId)"
        case _:
            return ""
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json",
            "Authorization": "Bearer \(bearerToken)",
            "Accept": "application/vnd.github.v3+json",
            "User-Agent": "LegionTest",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
    }
}
