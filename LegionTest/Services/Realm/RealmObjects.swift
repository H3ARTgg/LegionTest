import RealmSwift

final class RepoObject: Object {
    @Persisted var id: Int
    @Persisted var userId: Int
    @Persisted var name: String
    @Persisted var fullName: String
    @Persisted var repoDescription: String?
}
