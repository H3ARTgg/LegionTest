import Foundation

struct SearchResponce: Codable {
    let items: [Repo]
}

struct Repo: Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case name, id, description, owner
        case fullName = "full_name"
    }
}

struct Owner: Codable {
    let id: Int
}
