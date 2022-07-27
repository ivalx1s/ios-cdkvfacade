import CoreDataKVFacade

@objc(ContactEntity)
public class ContactEntity: CDKeyValueEntity {
    public override static var meta: KVEntityMeta {
        .init(entityName: "ContactEntity", type: .kv)
    }
}
