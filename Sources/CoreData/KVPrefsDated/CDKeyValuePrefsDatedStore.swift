import Foundation
import CoreData

open class CDKeyValuePrefsDatedStore: KeyValuePrefsDatedStore {
    public typealias KVEntity = AnyKVPrefDated

    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()

    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext

    public init(persistenceManager: CDPersistenceManager) {
        self.viewContext = persistenceManager.viewContext
        self.bgContext = persistenceManager.backgroundContext
    }

    public final func read<Model>(from entity: CDKeyValueDatedEntity.Type) throws
            -> Model? where Model: KVEntity {
        try internalRead(
                from: entity,
                predicate: CDFPredicate.key(operation: .equals(key: Model.key))
        )
    }

    public final func read<Model>(from entity: CDKeyValueDatedEntity.Type, predicate: CDFPredicate) throws
            -> Model? where Model: KVEntity {

        try internalRead(
                from: entity,
                predicate: .composite(operation: .and, predicates: [
                    CDFPredicate.key(operation: .equals(key: Model.key)),
                    predicate
                ])
        )
    }

    public final func upsert<Model>(entity: CDKeyValueDatedEntity.Type, _ item: Model) throws
            where Model: KVEntity {

        print("***** upsert start: \(entity.self)")

        let context = bgContext
        try context.execute(entity.deleteRequest(predicate: CDFPredicate.key(operation: .equals(key: Model.key))))
        try createDbEntity(entity: entity, item: item, context: context)

        print("***** upsert end: \(entity.self)")
    }

    private final func internalRead<Model>(from entity: CDKeyValueDatedEntity.Type, predicate: CDFPredicate) throws
            -> Model? where Model: KVEntity {

        print("***** read started: \(entity.self)")

        let entity: Model? = try viewContext
                .fetch(entity.fetchRequest(predicate: predicate))
                .compactMap(decodeEntity).first

        print("***** read ended: \(entity.self) \(entity != nil)")

        return entity
    }

    private func createDbEntity<Model>(entity: CDKeyValueDatedEntity.Type, item: Model, context: NSManagedObjectContext) throws
            where Model: KVEntity {

        guard let data = encodeEntity(item: item) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = entity.init(context: context)
        newItem.key = Model.key
        newItem.value = data
        newItem.createdAt = item.createdAt

        try context.save()
    }

    private final func encodeEntity<Model>(item: Model) -> Data? where Model: Encodable {
        try? encoder.encode(item)
    }

    private final func decodeEntity<Model>(_ obj: Any) throws -> Model? where Model: Decodable {
        guard let entity = obj as? CDKeyValueEntity else {
            throw CDError.failedToDecodeEntity
        }

        return try self.decoder.decode(Model.self, from: entity.value)
    }
}
