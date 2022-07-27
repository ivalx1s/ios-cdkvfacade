import CoreDataKVFacade

@objc(UserPrefsEntity)
public class UserPrefsEntity: CDKeyValueEntity {
    public override static var meta: KVEntityMeta {
        .init(entityName: "UserPrefsEntity", type: .kvPrefs)
    }
}
