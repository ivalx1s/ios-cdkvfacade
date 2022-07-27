import Foundation
import CoreData


@objc(KeyValueEntity)
open class CDKeyValueEntity: NSManagedObject, Identifiable {
    @NSManaged public var key: String
    @NSManaged public var value: Data

    open class var meta: KVEntityMeta {
        fatalError("Base KV entity is not supposed to be used directly. Override the entity name in your subclass")
    }

    public final class func fetchAllRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        return fetchRequest
    }

    public final class func fetchRequest(key: KVEntityId) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = NSPredicate(format: "key == %@", key)

        return fetchRequest
    }

    public final class func fetchRequest(keys: [KVEntityId]) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = NSPredicate(format: "key in %@", keys)

        return fetchRequest
    }

    public final class func deleteRequest(keys: [KVEntityId]) -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = NSPredicate(format: "key IN %@", keys)

        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }

    public final class func deleteRequest(key: KVEntityId) -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = NSPredicate(format: "key == %@", key)

        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }

    public final class func deleteAllRequest() -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
}
