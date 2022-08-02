import Foundation
import CoreData

open class CDKeyValueWithForeignKeyEntity: CDKeyValueEntity {
    @NSManaged public var foreignKey: String?

    open class override var meta: KVEntityMeta {
        fatalError("Base KV entity is not supposed to be used directly. Override the entity name in your subclass")
    }

    @nonobjc public class func fetchRequest(foreignKey: KVEntityId) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = NSPredicate(format: "foreignKey == %@", foreignKey)

        return fetchRequest
    }

    @nonobjc public class func deleteRequest(foreignKey: KVEntityId) -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = NSPredicate(format: "foreignKey == %@", foreignKey)

        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
}
