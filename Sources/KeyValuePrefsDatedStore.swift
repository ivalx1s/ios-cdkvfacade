import Foundation

public protocol AnyKVPrefDated: AnyKVPref, KVDated {}

public protocol KeyValuePrefsDatedStore {
    func read<KVEntity>(from entity: CDKeyValueDatedEntity.Type) throws -> KVEntity?
            where KVEntity: AnyKVPrefDated

    func read<Model>(from entity: CDKeyValueDatedEntity.Type, predicate: CDFPredicate) throws
            -> Model? where Model: AnyKVPrefDated

    func upsert<KVEntity>(entity: CDKeyValueDatedEntity.Type, _ item: KVEntity) throws
            where KVEntity: AnyKVPrefDated
}
