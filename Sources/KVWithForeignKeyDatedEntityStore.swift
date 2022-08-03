import Foundation

public protocol KVWithForeignKeyDatedEntityStore: KVWithForeignKeyEntityStore
        where KVEntity: KVDated {
    func readAll(createDateGreaterThan: Date) throws -> [KVEntity]
    func readAll(createDateLessThan: Date) throws -> [KVEntity]
    func readAllBetween(start: Date, end: Date) throws -> [KVEntity]

    func readAll(fk: String, createDateGreaterThan: Date) throws -> [KVEntity]
    func readAll(fk: String, createDateLessThan: Date) throws -> [KVEntity]
    func readAllBetween(fk: String, start: Date, end: Date) throws -> [KVEntity]

    func readAll(fks: [String], createDateGreaterThan: Date) throws -> [KVEntity]
    func readAll(fks: [String], createDateLessThan: Date) throws -> [KVEntity]
    func readAllBetween(fks: [String], start: Date, end: Date) throws -> [KVEntity]
}
