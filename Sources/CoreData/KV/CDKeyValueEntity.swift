import Foundation
import CoreData

@objc(KeyValueEntity)
open class CDKeyValueEntity: NSManagedObject, Identifiable {
    @NSManaged public var key: String
    @NSManaged public var value: Data

    open class var allowedPredicates: [CDFPredicate.PType] { [.compound, .key] }

    open class var meta: KVEntityMeta {
        fatalError("Base KV entity is not supposed to be used directly. Override the entity name in your subclass")
    }

    public final class func fetchRequest(predicate: CDFPredicate?, fetchOptions: CDFetchOptions? = nil, sortDescriptors: [CDSortDescriptor] = []) throws -> NSFetchRequest<NSFetchRequestResult> {
        try checkPredicateAvailable(predicate: predicate, allowedTypes: allowedPredicates)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = CDPredicateBuilder.build(predicate)
        if let fetchOptions = fetchOptions {
            fetchRequest.fetchOffset = fetchOptions.offset
            fetchRequest.fetchLimit = fetchOptions.limit
        }

        if !sortDescriptors.isEmpty {
            fetchRequest.sortDescriptors = sortDescriptors.map { $0.asNSSortDescriptor }
        }

        return fetchRequest
    }

    public final class func deleteRequest(predicate: CDFPredicate?, fetchOptions: CDFetchOptions? = nil) throws -> NSBatchDeleteRequest {
        try checkPredicateAvailable(predicate: predicate, allowedTypes: allowedPredicates)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: meta.entityName)
        fetchRequest.predicate = CDPredicateBuilder.build(predicate)
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }

    private class func checkPredicateAvailable(predicate: CDFPredicate?, allowedTypes: [CDFPredicate.PType]) throws {
        guard let predicate = predicate else { return }

        guard predicate.containsOnly(types: allowedTypes) else {
            throw CDError.predicateNotAvailableForDbEntity(availableTypes: allowedTypes)
        }
    }
}
