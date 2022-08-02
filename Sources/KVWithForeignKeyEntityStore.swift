import Foundation

public protocol KVWithForeignKeyIdentifiable: KVIdentifiable {
    var foreignKey: KVEntityId { get }
}

public protocol KVWithForeignKeyEntityStore: KVEntityStore
        where KVEntity: KVWithForeignKeyIdentifiable {

    func readAll(foreignKey: KVEntityId) throws -> [KVEntity]
    func deleteAll(foreignKey: KVEntityId) throws
}
