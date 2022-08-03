import Foundation
import CoreData

open class CDKeyValueWithForeignKeyDatedEntityStore<DBEntity, Model>
        : CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>, KVWithForeignKeyDatedEntityStore
        where DBEntity: CDKeyValueWithForeignKeyDatedEntity, Model: Codable & KVWithForeignKeyIdentifiable & KVDated {

    public typealias KVEntity = Model

    public func readAll(fks: [String], createDateGreaterThan: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fks): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .containsIn(keys: fks)),
                                    .createDate(operation: .greaterThan(date: createDateGreaterThan)),
                                ]
                        )
                ))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fks): \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public func readAll(fks: [String], createDateLessThan: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fks): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .containsIn(keys: fks)),
                                    .createDate(operation: .lessThan(date: createDateLessThan)),
                                ]
                        )
                ))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fks): \(DBEntity.meta.entityName): \(entities.count)")
        return entities
    }

    public func readAllBetween(fks: [String], start: Date, end: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fks): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .containsIn(keys: fks)),
                                    .createDate(operation: .between(start: start, end: end)),
                                ]
                        )
                ))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fks): \(DBEntity.meta.entityName): \(entities.count)")
        return entities
    }

    public func readAll(createDateGreaterThan: Date) throws -> [KVEntity] {
        print("***** readAll start: \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .createDate(operation: .greaterThan(date: createDateGreaterThan))
                ))
                .compactMap(decodeEntity)

        print("***** readAll end: \(DBEntity.meta.entityName): \(entities.count)")

        return entities

    }

    public func readAll(createDateLessThan: Date) throws -> [KVEntity] {
        print("***** readAll start: \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .createDate(operation: .lessThan(date: createDateLessThan))
                ))
                .compactMap(decodeEntity)

        print("***** readAll end: \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public func readAllBetween(start: Date, end: Date) throws -> [KVEntity] {
        print("***** readAll start: \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .createDate(operation: .between(start: start, end: end))
                ))
                .compactMap(decodeEntity)

        print("***** readAll end: \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public func readAll(fk: String, createDateGreaterThan: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fk): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .equals(key: fk)),
                                    .createDate(operation: .greaterThan(date: createDateGreaterThan)),
                                ]
                        )
                ))
                .compactMap(decodeEntity)

        print("***** readAll end with: \(fk): \(DBEntity.meta.entityName): \(entities.count)")

        return entities
    }

    public func readAll(fk: String, createDateLessThan: Date) throws -> [KVEntity] {
        print("***** readAll start with: \(fk): \(DBEntity.meta.entityName)")
        let entities: [KVEntity] = try viewContext
                .fetch(DBEntity.fetchRequest(
                        predicate: .composite(
                                operation: .and,
                                predicates: [
                                    .foreignKey(operation: .equals(key: fk)),
                                    .createDate(operation: .lessThan(date: createDateLessThan)),
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
