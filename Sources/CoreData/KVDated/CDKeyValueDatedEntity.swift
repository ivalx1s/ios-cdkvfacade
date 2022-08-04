import Foundation
import CoreData

open class CDKeyValueDatedEntity: CDKeyValueEntity {
    @NSManaged public var createdAt: Date

    public static override var allowedPredicates: [CDFPredicate.PType] { [.compound, .key, .createDate] }

    open class override var meta: KVEntityMeta {
        fatalError("Base KV entity is not supposed to be used directly. Override the entity name in your subclass")
    }
}
