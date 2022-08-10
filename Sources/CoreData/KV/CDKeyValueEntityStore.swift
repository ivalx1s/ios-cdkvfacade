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

    public func read(predicate: CDFPredicate) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: predicate, fetchOptions: .none, sortDescriptions: [])
    }

    public func read(predicate: CDFPredicate, fetchOptions: CDFetchOptions) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: predicate, fetchOptions: fetchOptions, sortDescriptions: [])
    }

    public final func readAll() throws -> [Model] {
        try internalReadAll(context: viewContext, predicate: .none, fetchOptions: .none, sortDescriptions: [])
    }

    public final func read(fetchOptions: CDFetchOptions) throws -> [Model] {
        try internalReadAll(context: viewContext, predicate: .none, fetchOptions: fetchOptions, sortDescriptions: [])
    }

    public final func read(where condition: (Model) -> Bool) throws -> [Model] {
        let result = try readAll()
                .filter { condition($0) }

        return result
    }

    func internalReadAll(context: NSManagedObjectContext, predicate: CDFPredicate?, fetchOptions: CDFetchOptions?, sortDescriptions: [CDSortDescriptor]) throws -> [Model] {
        print("***** read started: \(DBEntity.meta.entityName)")

        let entities: [Model] = try context
            .fetch(DBEntity.fetchRequest(predicate: predicate, fetchOptions: fetchOptions, sortDescriptors: sortDescriptions))
            .compactMap(decodeEntity)

        print("***** read ended: \(DBEntity.meta.entityName) \(entities.count)")

        return entities
    }

    @available(iOS 15, macOS 12, *)
    public final func insert(_ entities: [Model]) throws {
        let context = bgContext
        try internalInsert(context: context, entities: entities)
    }

    @available(iOS 15, macOS 12, *)
    private func internalInsert(context: NSManagedObjectContext, entities: [Model]) throws {
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
        try upsert([entity])
    }

    public final func upsert(_ entities: [Model]) throws {
        print("***** upsert start: \(DBEntity.meta.entityName)")
        let context = bgContext
        try internalDelete(
                context: context,
                predicate: .key(operation: .containedIn(keys: entities.map {$0.key}))
        )
        try internalInsert(
                context: context,
                entities: entities
        )

        print("***** upsert end: \(DBEntity.meta.entityName)")
    }

    public func delete(predicate: CDFPredicate) throws {
        try internalDelete(context: bgContext, predicate: predicate)
    }

    public final func delete(_ entity: Model) throws {
        try delete([entity])
    }

    public final func delete(_ entities: [Model]) throws {
        try internalDelete(context: bgContext, predicate: .key(operation: .containedIn(keys: entities.map {$0.key})))
    }

    public final func delete(where condition: (Model) -> Bool) throws {
        print("***** delete start: \(DBEntity.meta.entityName)")
        let entitiesToDelete = try readAll()
                .filter { condition($0) }

        try self.delete(entitiesToDelete)
    }

    public final func deleteAll() throws {
        try internalDelete(context: bgContext, predicate: .none)
    }

    private final func internalDelete(context: NSManagedObjectContext, predicate: CDFPredicate?) throws {
        print("***** deleteAll start: \(DBEntity.meta.entityName)")
        try! context.execute(DBEntity.deleteRequest(predicate: predicate))
        print("***** deleteAll end: \(DBEntity.meta.entityName)")
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
