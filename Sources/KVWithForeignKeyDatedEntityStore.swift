import Foundation

public protocol KVWithForeignKeyDatedEntityStore: KVWithForeignKeyEntityStore
        where KVEntity: KVDated {
}
