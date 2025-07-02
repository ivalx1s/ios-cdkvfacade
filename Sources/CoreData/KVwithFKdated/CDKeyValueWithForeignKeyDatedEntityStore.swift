import Foundation
import CoreData

open class CDKeyValueWithForeignKeyDatedEntityStore<DBEntity, Model>
        : CDKeyValueWithForeignKeyEntityStore<DBEntity, Model>, KVWithForeignKeyDatedEntityStore
        where DBEntity: CDKeyValueWithForeignKeyDatedEntity, Model: Codable & KVWithForeignKeyIdentifiable & KVDated {


    public typealias KVEntity = Model

    open func readAll(sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: .none, fetchOptions: .none, sortDescriptions: sortDescriptors)
    }

    open func read(predicate: CDFPredicate, sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: predicate, fetchOptions: .none, sortDescriptions: sortDescriptors)
    }

    open func read(fetchOptions: CDFetchOptions, sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: .none, fetchOptions: fetchOptions, sortDescriptions: sortDescriptors)
    }

    open func read(predicate: CDFPredicate, fetchOptions: CDFetchOptions, sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: predicate, fetchOptions: fetchOptions, sortDescriptions: sortDescriptors)
    }

    open override func createDbEntity(entity: KVEntity, context: NSManagedObjectContext) throws {
        let data = try encodeEntity(entity: entity)

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.foreignKey = entity.foreignKey
        newItem.createdAt = entity.createdAt
        newItem.value = data
    }
}
