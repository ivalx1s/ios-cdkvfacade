import Foundation

public protocol KVWithForeignKeyDatedEntityStore: KVWithForeignKeyEntityStore
        where KVEntity: KVDated {
    func readAll(fk: String, greaterThan: Date) throws -> [KVEntity]
    func readAll(fk: String, lessThan: Date) throws -> [KVEntity]
    func readAllBetween(fk: String, start: Date, end: Date) throws -> [KVEntity]
}
