import Foundation
import CoreData

open class CDKeyValueWithForeignKeyDatedEntity: CDKeyValueWithForeignKeyEntity {
    @NSManaged public var createdAt: Date

    open class override var meta: KVEntityMeta {
        fatalError("Base KV entity is not supposed to be used directly. Override the entity name in your subclass")
    }
}
