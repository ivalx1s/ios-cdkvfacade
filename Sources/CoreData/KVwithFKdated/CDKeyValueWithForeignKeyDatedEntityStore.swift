import Foundation
import CoreData

open class CDKeyValueWithForeignKeyDatedEntityStore<DBEntity, Model>
        : CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>, KVWithForeignKeyDatedEntityStore
        where DBEntity: CDKeyValueWithForeignKeyDatedEntity, Model: Codable & KVWithForeignKeyIdentifiable & KVDated {

    public typealias KVEntity = Model

    public override func createDbEntity(entity: Model, context: NSManagedObjectContext) throws {
        guard let data = encodeEntity(entity: entity) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.foreignKey = entity.foreignKey
        newItem.createdAt = entity.createdAt
        newItem.value = data
    }
}
