import Foundation

public protocol KVDated {
    var createdAt: Date { get }
}

public protocol KVDatedEntityStore: KVEntityStore
        where KVEntity: KVDated {

    func readAll(sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity]
    func read(predicate: CDFPredicate, sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity]

    func read(fetchOptions: CDFetchOptions, sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity]
    func read(predicate: CDFPredicate, fetchOptions: CDFetchOptions, sortDescriptors: [CDSortDescriptor]) throws -> [KVEntity]
}
