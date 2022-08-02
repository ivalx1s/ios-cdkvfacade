import Foundation
import CoreData

open class CDKeyValueDatedEntityStore<DBEntity, Model>
        : CDKeyValueEntityStore<DBEntity, Model>, KVDatedEntityStore
        where DBEntity: CDKeyValueDatedEntity, Model: Codable & KVIdentifiable & KVDated {

    public typealias KVEntity = Model

    public final override func createDbEntity(entity: Model, context: NSManagedObjectContext) throws {
        guard let data = encodeEntity(entity: entity) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.createdAt = entity.createdAt
        newItem.value = data
    }
}
