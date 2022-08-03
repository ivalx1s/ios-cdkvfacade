import Foundation

public protocol KVWithForeignKeyIdentifiable: KVIdentifiable {
    var foreignKey: KVEntityId { get }
}

public protocol KVWithForeignKeyEntityStore: KVEntityStore
        where KVEntity: KVWithForeignKeyIdentifiable {

    func readAll(fk: KVEntityId) throws -> [KVEntity]
    func readAll(fks: [KVEntityId]) throws -> [KVEntity]
    func deleteAll(fk: KVEntityId) throws
    func deleteAll(fks: [KVEntityId]) throws
}
