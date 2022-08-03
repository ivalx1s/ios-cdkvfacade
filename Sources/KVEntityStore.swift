import Foundation

public typealias KVEntityId = String

public protocol KVIdentifiable {
    var key: KVEntityId { get }
}

public protocol KVEntityStore {
    associatedtype KVEntity: Codable, KVIdentifiable

    func insert(_ entities: [KVEntity]) throws
    func upsert(_ entity: KVEntity) throws
    func upsert(_ entities: [KVEntity]) throws
    func read(key: KVEntityId) throws -> KVEntity?
    func read(keys: [KVEntityId]) throws -> [KVEntity]
    func read(where condition: (KVEntity)->Bool) throws -> [KVEntity]
    func readAll() throws -> [KVEntity]
    func delete(key: KVEntityId) throws
    func delete(keys: [KVEntityId]) throws
    func delete(_ entity: KVEntity) throws
    func delete(_ entities: [KVEntity]) throws
    func delete(where condition: (KVEntity)->Bool) throws
    func deleteAll() throws
}
