import Foundation
import CoreData

open class CDKeyValueWithForeignKeyEntity: CDKeyValueEntity {
    @NSManaged public var foreignKey: String?

    open class override var meta: KVEntityMeta {
        fatalError("Base KV entity is not supposed to be used directly. Override the entity name in your subclass")
    }
}
