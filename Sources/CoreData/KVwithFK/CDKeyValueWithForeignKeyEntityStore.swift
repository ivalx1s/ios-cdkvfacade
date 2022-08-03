import Foundation
import CoreData

open class CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>
        : CDKeyValueEntityStore<DBEntity, Model>, KVWithForeignKeyEntityStore
        where DBEntity: CDKeyValueWithForeignKeyEntity, Model: Codable & KVWithForeignKeyIdentifiable {

    public typealias KVEntity = Model

    public func readAll(fks: [KVEntityId]) throws -> [Model] {
        print("***** readAll start with: \(fks): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(predicate: .foreignKey(operation: .containsIn(keys: fks))))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fks): \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public func deleteAll(fks: [KVEntityId]) throws {
        print("***** deleteAll start with: \(fks): \(DBEntity.meta.entityName)")
        let _ = try? bgContext.execute(DBEntity.deleteRequest(predicate: .foreignKey(operation: .containsIn(keys: fks))))
        print("***** deleteAll end with: \(fks): \(DBEntity.meta.entityName)")
    }

    public override func createDbEntity(entity: Model, context: NSManagedObjectContext) throws {
        guard let data = encodeEntity(entity: entity) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.foreignKey = entity.foreignKey
        newItem.value = data
    }

    public final func readAll(fk: KVEntityId) throws -> [KVEntity] {
        print("***** readAll start with: \(fk): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(predicate: .foreignKey(operation: .equals(key: fk))))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fk): \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public final func deleteAll(fk: KVEntityId) throws {
        print("***** deleteAll start with: \(fk): \(DBEntity.meta.entityName)")
        let _ = try? bgContext.execute(DBEntity.deleteRequest(predicate: .foreignKey(operation: .equals(key: fk))))
        print("***** deleteAll end with: \(fk): \(DBEntity.meta.entityName)")
    }
}
