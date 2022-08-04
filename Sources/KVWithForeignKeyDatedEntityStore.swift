import Foundation

public typealias CDDateRange = (start: Date, end: Date)

public protocol KVWithForeignKeyDatedEntityStore: KVWithForeignKeyEntityStore, KVDatedEntityStore {
    func read(predicate: CDFPredicate, fetchOptions: CDFetchOptions, sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity]
}
