import Foundation
import CoreData

open class CDKeyValuePrefsStore: KeyValuePrefsStore {
    public typealias KVEntity = AnyKVPref

    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()

    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext

    public init(persistenceManager: CDPersistenceManager) {
        self.viewContext = persistenceManager.viewContext
        self.bgContext = persistenceManager.backgroundContext
    }

    open func read<Model>(from entity: CDKeyValueEntity.Type) throws
            -> Model? where Model: KVEntity {

        print("***** read started: \(entity.self)")

        let entity: Model? = try viewContext
                .fetch(entity.fetchRequest(predicate: CDFPredicate.key(operation: .equals(key: Model.key))))
                .compactMap {
                    let model: Model? = try decodeEntity($0)
                    return model
                }
                .first

            print("***** read ended: \(entity.self) \(entity != nil)")

        return entity
    }

    open func upsert<Model>(to entity: CDKeyValueEntity.Type, _ item: Model) throws
            where Model: KVEntity {

        print("***** upsert start: \(entity.self)")

        let context = bgContext
        try context.execute(entity.deleteRequest(predicate: CDFPredicate.key(operation: .equals(key: Model.key))))
        try createDbEntity(entity: entity, item: item, context: context)

        print("***** upsert end: \(entity.self)")
    }

    open func delete(by key: KVEntityId, from entity: CDKeyValueEntity.Type) throws {
        print("***** delete by key \(key) start: \(entity.self)")
        try bgContext.execute(entity.deleteRequest(predicate: CDFPredicate.key(operation: .equals(key: key))))
        print("***** delete by key \(key) end: \(entity.self)")
    }

    private func createDbEntity<Model>(entity: CDKeyValueEntity.Type, item: Model, context: NSManagedObjectContext) throws
            where Model: KVEntity {

        guard let data = encodeEntity(item: item) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = entity.init(context: context)
        newItem.key = Model.key
        newItem.value = data

        try context.save()
    }

    private final func encodeEntity<Model>(item: Model) -> Data?
            where Model: Encodable {
        try? encoder.encode(item)
    }

    private final func decodeEntity<Model>(_ obj: Any) throws -> Model?
            where Model: Decodable {
        guard let entity = obj as? CDKeyValueEntity else {
            throw CDError.failedToDecodeEntity
        }

        return try self.decoder.decode(Model.self, from: entity.value)
    }
}
