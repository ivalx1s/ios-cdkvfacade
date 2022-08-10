import Foundation

public typealias KVEntityId = String

public protocol KVIdentifiable {
    var key: KVEntityId { get }
}

// public typealias KVEntity = Codable & KVIdentifiable

public protocol KVEntityStore {
    associatedtype KVEntity: Codable, KVIdentifiable

    func insert(_ entities: [KVEntity]) throws
    func upsert(_ entity: KVEntity) throws
    func upsert(_ entities: [KVEntity]) throws

    func readAll() throws -> [KVEntity]
    func read(predicate: CDFPredicate) throws -> [KVEntity]
    func read(fetchOptions: CDFetchOptions) throws -> [KVEntity]
    func read(predicate: CDFPredicate, fetchOptions: CDFetchOptions) throws -> [KVEntity]
    func read(where condition: (KVEntity)->Bool) throws -> [KVEntity] // note: it's not optimized

    func deleteAll() throws
    func delete(predicate: CDFPredicate) throws
    func delete(_ entity: KVEntity) throws
    func delete(_ entities: [KVEntity]) throws
    func delete(where condition: (KVEntity)->Bool) throws
}
