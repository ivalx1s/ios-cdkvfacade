import Foundation
import CoreDataKVFacade

extension UserPrefs: KVPrefIdentifiable {
    static var key: String { "userPrefs" }
}

class UserPrefsStore: CDKeyValuePrefsStore {
    func getPrefs() -> UserPrefs {
        let entity: UserPrefs? = try? read(from: UserPrefsEntity.self)
        return entity ?? UserPrefs.defaultValue
    }

    func setPrefs(_ prefs: UserPrefs) {
        try? self.upsert(entity: UserPrefsEntity.self, prefs)
    }
}
