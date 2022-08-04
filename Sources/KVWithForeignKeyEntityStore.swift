import Foundation

public protocol KVWithForeignKeyIdentifiable: KVIdentifiable {
    var foreignKey: KVEntityId { get }
}

public protocol KVWithForeignKeyEntityStore: KVEntityStore
        where KVEntity: KVWithForeignKeyIdentifiable {
}
