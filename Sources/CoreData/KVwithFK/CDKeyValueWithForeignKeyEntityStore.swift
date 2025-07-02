import Foundation
import CoreData

open class CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>
        : CDKeyValueEntityStore<DBEntity, Model>, KVWithForeignKeyEntityStore
        where DBEntity: CDKeyValueWithForeignKeyEntity, Model: Codable & KVWithForeignKeyIdentifiable {

    public typealias KVEntity = Model

    open override func createDbEntity(entity: KVEntity, context: NSManagedObjectContext) throws {
        let data = try encodeEntity(entity: entity)

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.foreignKey = entity.foreignKey
        newItem.value = data
    }
}
