import Foundation

public protocol KVDated {
    var createdAt: Date { get }
}

public protocol KVDatedEntityStore: KVEntityStore
        where KVEntity: KVDated {
}
