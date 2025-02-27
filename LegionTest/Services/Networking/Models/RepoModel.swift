struct RepoModel: Hashable, Identifiable, Codable {
    let nextUrl: String?
    let lastUrl: String?
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RepoModel, rhs: RepoModel) -> Bool {
        return lhs.id == rhs.id
    }
}
