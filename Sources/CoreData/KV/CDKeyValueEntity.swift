import Foundation
import CoreData


@objc(KeyValueEntity)
open class CDKeyValueEntity: NSManagedObject, Identifiable {
    @NSManaged public var key: String
    @NSManaged public var value: Data

    open class var meta: KVEntityMeta {
        fatalError("Base KV entity is not supposed to be used directly. Override the entity name in your subclass")
    }

    public final class func fetchRequest(predicate: CDFPredicate?) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = CDPredicateBuilder.build(predicate)
        return fetchRequest
    }

    public final class func deleteRequest(predicate: CDFPredicate?) -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = CDPredicateBuilder.build(predicate)
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
}
