import Foundation
import CoreData

open class CDKeyValueWithForeignKeyDatedEntityStore<DBEntity, Model>
        : CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>, KVWithForeignKeyDatedEntityStore
        where DBEntity: CDKeyValueWithForeignKeyDatedEntity, Model: Codable & KVWithForeignKeyIdentifiable & KVDated {

    public typealias KVEntity = Model

    public func readAll(fk: String, greaterThan: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fk): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .equals(key: fk)),
                                    .createDate(operation: .greaterThan(date: greaterThan)),
                                ]
                        )
                ))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fk): \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public func readAll(fk: String, lessThan: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fk): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .equals(key: fk)),
                                    .createDate(operation: .lessThan(date: lessThan)),
                                ]
                        )
                ))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fk): \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public func readAllBetween(fk: String, start: Date, end: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fk): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .equals(key: fk)),
                                    .createDate(operation: .between(start: start, end: end)),
                                ]
                        )
                ))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fk): \(DBEntity.meta.entityName): \(entities.count)")

        return entities

    }

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
