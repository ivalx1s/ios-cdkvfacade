import Foundation
import CoreData

open class CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>
        : CDKeyValueEntityStore<DBEntity, Model>, KVWithForeignKeyEntityStore
        where DBEntity: CDKeyValueWithForeignKeyEntity, Model: Codable & KVWithForeignKeyIdentifiable {

    public typealias KVEntity = Model

    public override func createDbEntity(entity: Model, context: NSManagedObjectContext) throws {
        guard let data = encodeEntity(entity: entity) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.foreignKey = entity.foreignKey
        newItem.value = data
    }

    public final func readAll(foreignKey: KVEntityId) throws -> [KVEntity] {
        print("***** readAll start with: \(foreignKey): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(foreignKey: foreignKey))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(foreignKey): \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public final func deleteAll(foreignKey: KVEntityId) throws {
        print("***** deleteAll start with: \(foreignKey): \(DBEntity.meta.entityName)")
        let _ = try? bgContext.execute(DBEntity.deleteRequest(foreignKey: foreignKey))
        print("***** deleteAll end with: \(foreignKey): \(DBEntity.meta.entityName)")
    }
}
