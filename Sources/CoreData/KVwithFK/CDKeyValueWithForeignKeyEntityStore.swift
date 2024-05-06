import Foundation
import CoreData

open class CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>
        : CDKeyValueEntityStore<DBEntity, Model>, KVWithForeignKeyEntityStore
        where DBEntity: CDKeyValueWithForeignKeyEntity, Model: Codable & KVWithForeignKeyIdentifiable {

    public typealias KVEntity = Model

    open override func createDbEntity(entity: KVEntity, context: NSManagedObjectContext) throws {
        guard let data = encodeEntity(entity: entity) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.foreignKey = entity.foreignKey
        newItem.value = data
    }
}
