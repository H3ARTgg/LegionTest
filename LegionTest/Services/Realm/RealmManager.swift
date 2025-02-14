import RealmSwift

// MARK: - Results
extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}

// MARK: - RealmManagerProtocol
protocol RealmManagerProtocol: AnyObject {
    func writeRepo(_ repo: RepoModel)
    func removeRepo(_ repo: RepoModel)
    func getRepos() -> [RepoModel]
    func convert(_ object: RepoObject) -> RepoModel
    func isRepoContains(_ repo: RepoModel) -> Bool
}

// MARK: - RealmManager
final class RealmManager: RealmManagerProtocol {
    let realm = try! Realm()
    
    // MARK: - Methods
    private func readData<T: Object>(forType: T.Type = T.self) -> [T]  {
        var object = realm.objects(T.self).toArray()
        object.reverse()
        return object
    }
    
    private func removeAll<T: Object>(forType: T.Type) {
        let objects = readData(forType: T.self)
        try! self.realm.write {
            realm.delete(objects)
        }
    }
}

// MARK: - RealmManagerProtocol
extension RealmManager {
    func writeRepo(_ repo: RepoModel) {
        let object = RepoObject()
        
        object.id = repo.id
        object.name = repo.name
        object.fullName = repo.fullName
        object.repoDescription = repo.description
        object.userId = repo.owner.id
        
        try! self.realm.write({
            realm.add(object)
        })
    }
    
    func getRepos() -> [RepoModel] {
        readData(forType: RepoObject.self).map { convert($0) }
    }
    
    func convert(_ object: RepoObject) -> RepoModel {
        RepoModel(nextUrl: nil, lastUrl: nil, id: object.id, name: object.name, fullName: object.fullName, owner: Owner(id: object.userId), description: object.repoDescription)
    }
    
    func removeRepo(_ repo: RepoModel) {
        guard let object = readData(forType: RepoObject.self).first(where: { $0.id == repo.id }) else { return }
        try! self.realm.write {
            realm.delete(object)
        }
    }
    
    func isRepoContains(_ repo: RepoModel) -> Bool {
        guard let _ = readData(forType: RepoObject.self).first(where: { $0.id == repo.id }) else { return false }
        return true
    }
}
