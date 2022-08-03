import Foundation
import CoreData

open class CDKeyValueEntityStore<DBEntity, Model> : KVEntityStore
        where DBEntity: CDKeyValueEntity, Model: Codable & KVIdentifiable {
    public typealias KVEntity = Model

    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()

    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext

    public init(persistenceManager: CDPersistenceManager) {
        self.viewContext = persistenceManager.viewContext
        self.bgContext = persistenceManager.backgroundContext
    }

    public final func read(key: KVEntityId) throws -> Model? {
        try self.read(keys: [key])
                .first
    }

    public final func read(keys: [KVEntityId]) throws -> [KVEntity] {
        let context = viewContext

        print("***** read started: \(DBEntity.meta.entityName)")

        let entities: [Model] = try context
                .fetch(DBEntity.fetchRequest(predicate: CDFPredicate.key(operation: .containsIn(keys: keys))))
                .compactMap(decodeEntity)

        print("***** read ended: \(DBEntity.meta.entityName) \(entities.count)")

        return entities
    }

    public final func read(where condition: (Model) -> Bool) throws -> [Model] {
        let result = try readAll()
                .filter { condition($0) }

        return result
    }

    public final func readAll() throws -> [Model] {
        print("***** read started: \(DBEntity.meta.entityName)")
        let entities: [Model]  = try internalReadAll(context: viewContext)
        print("***** read ended: \(DBEntity.meta.entityName) \(entities.count)")

        return entities
    }

    public final func internalReadAll(context: NSManagedObjectContext) throws -> [Model] {
        try context
                .fetch(DBEntity.fetchRequest())
                .compactMap(decodeEntity)
    }

    @available(iOS 15, macOS 12, *)
    public final func insert(_ entities: [Model]) throws {
        let context = bgContext
        try internalInsert(entities, context: context)
    }

    @available(iOS 15, macOS 12, *)
    private func internalInsert(_ entities: [Model], context: NSManagedObjectContext) throws {
        try context.performAndWait {
            print("***** insert started: \(DBEntity.meta.entityName)")
            try entities
                    .forEach { //todo is it possible to use concurrent foreach
                         try createDbEntity(entity: $0, context: context)
                    }
            try context.save()
            print("***** inserted: \(DBEntity.meta.entityName) \(entities.count)")
        }
    }

    public final func upsert(_ entity: Model) throws {
        print("***** upsert start: \(DBEntity.meta.entityName)")
        let context = bgContext
        try internalDelete([entity.key], context: context)
        try internalInsert([entity], context: context)
        print("***** upsert end: \(DBEntity.meta.entityName)")
    }

    public final func upsert(_ entities: [Model]) throws {
        print("***** upsert start: \(DBEntity.meta.entityName)")
        let context = bgContext
        try internalDelete(
                entities.map{$0.key},
                context: context
        )
        try internalInsert(
                entities,
                context: context
        )

        print("***** upsert end: \(DBEntity.meta.entityName)")
    }

    

    public final func delete(keys: [KVEntityId]) throws {
        print("***** delete start: \(DBEntity.meta.entityName)")
        let context = bgContext
        try? internalDelete(keys, context: context)
        print("***** delete end: \(DBEntity.meta.entityName)")
    }

    public final func delete(key: KVEntityId) throws {
       try self.delete(keys: [key])
    }

    public final func delete(_ entity: Model) throws {
        try delete([entity])
    }

    public final func delete(_ entities: [Model]) throws {
        try self.delete(keys: entities.map {$0.key})
    }

    public final func delete(where condition: (Model) -> Bool) throws {
        print("***** delete start: \(DBEntity.meta.entityName)")
        let keysToDelete = try readAll()
                .filter { condition($0) }
                .map { $0.key }

        try self.delete(keys: keysToDelete)
    }

    public final func deleteAll() throws {
        print("***** deleteAll start: \(DBEntity.meta.entityName)")
        let _ = try? bgContext.execute(DBEntity.deleteRequest(predicate: nil))
        print("***** deleteAll end: \(DBEntity.meta.entityName)")
    }

    public final func internalDelete(_ entityIds: [KVEntityId], context: NSManagedObjectContext) throws {
        let _ = try! context.execute(DBEntity.deleteRequest(predicate: .key(operation: .containsIn(keys: entityIds))))
    }

    public final func encodeEntity(entity: Model) -> Data? {
        try? encoder.encode(entity)
    }

    public final func decodeEntity(_ dbObject: Any) -> Model? {
        guard let entity = dbObject as? DBEntity else {
            return nil
        }

        return try? self.decoder.decode(Model.self, from: entity.value)
    }
    
    open func createDbEntity(entity: Model, context: NSManagedObjectContext) throws {
        guard let data = encodeEntity(entity: entity) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.value = data
    }
}
