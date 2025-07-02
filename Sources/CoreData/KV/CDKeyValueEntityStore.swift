import Foundation
import CoreData

open class CDKeyValueEntityStore<DBEntity, Model> : KVEntityStore
        where DBEntity: CDKeyValueEntity, Model: Codable & KVIdentifiable {

    public typealias KVEntity = Model

    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()

    var viewContext: NSManagedObjectContext {
        get throws { switch persistenceManager?.viewContext {
            case let .some(ctx): ctx
            case .none: throw CDError.noPersistenceManager
        }}
    }

    var bgContext: NSManagedObjectContext {
        get throws { switch persistenceManager?.backgroundContext {
            case let .some(ctx): ctx
            case .none: throw CDError.noPersistenceManager
        }}
    }

    private var persistenceManager: CDPersistenceManager?
    private var logger: CDLogger
    private var cryptoProvider: ICryptoProvider? { persistenceManager?.cryptoProvider }

    public init(
        persistenceManager: CDPersistenceManager?,
        logger: CDLogger = DefaultCDLogger.shared
    ) {
        self.persistenceManager = persistenceManager
        self.logger = logger
    }

    open func read(predicate: CDFPredicate) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: predicate, fetchOptions: .none, sortDescriptions: [])
    }

    open func read(predicate: CDFPredicate, fetchOptions: CDFetchOptions) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: predicate, fetchOptions: fetchOptions, sortDescriptions: [])
    }

    open func readAll() throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: .none, fetchOptions: .none, sortDescriptions: [])
    }

    open func read(fetchOptions: CDFetchOptions) throws -> [KVEntity] {
        try internalReadAll(context: viewContext, predicate: .none, fetchOptions: fetchOptions, sortDescriptions: [])
    }

    open func read(where condition: (KVEntity) -> Bool) throws -> [KVEntity] {
        let result = try readAll()
                .filter { condition($0) }

        return result
    }

    func internalReadAll(context: NSManagedObjectContext, predicate: CDFPredicate?, fetchOptions: CDFetchOptions?, sortDescriptions: [CDSortDescriptor]) throws -> [Model] {
        logger.log("***** read started: \(DBEntity.meta.entityName)")

        let entities: [KVEntity] = try context
            .fetch(DBEntity.fetchRequest(predicate: predicate, fetchOptions: fetchOptions, sortDescriptors: sortDescriptions))
            .compactMap(decodeEntity)

        logger.log("***** read ended: \(DBEntity.meta.entityName) \(entities.count)")

        return entities
    }

    @available(iOS 15, macOS 12, *)
    private func internalInsert(context: NSManagedObjectContext, entities: [KVEntity]) throws {
        try context.performAndWait {
            logger.log("***** insert started: \(DBEntity.meta.entityName)")
            try entities
                    .forEach { //todo is it possible to use concurrent foreach
                         try createDbEntity(entity: $0, context: context)
                    }
            try context.save()
            logger.log("***** inserted: \(DBEntity.meta.entityName) \(entities.count)")
        }
    }

    open func upsert(_ entity: KVEntity) throws {
        try upsert([entity])
    }

    open func upsert(_ entities: [KVEntity]) throws {
        guard !entities.isEmpty else { return }

        let context = try bgContext
        try internalDelete(
                context: context,
                predicate: .key(operation: .containedIn(keys: entities.map {$0.key}))
        )
        try internalInsert(
                context: context,
                entities: entities
        )
    }

    open func delete(predicate: CDFPredicate) throws {
        try internalDelete(context: bgContext, predicate: predicate)
    }

    open func delete(_ entity: KVEntity) throws {
        try delete([entity])
    }

    open func delete(_ entities: [KVEntity]) throws {
        guard !entities.isEmpty else { return }

        try internalDelete(context: bgContext, predicate: .key(operation: .containedIn(keys: entities.map {$0.key})))
    }

    open func delete(where condition: (KVEntity) -> Bool) throws {
        let entitiesToDelete = try readAll()
                .filter { condition($0) }

        try self.delete(entitiesToDelete)
    }

    open func deleteAll() throws {
        try internalDelete(context: bgContext, predicate: .none)
    }

    private final func internalDelete(context: NSManagedObjectContext, predicate: CDFPredicate?) throws {
        logger.log("***** deleteAll start: \(DBEntity.meta.entityName)")
        try! context.execute(DBEntity.deleteRequest(predicate: predicate))
        logger.log("***** deleteAll end: \(DBEntity.meta.entityName)")
    }

    open func encodeEntity(entity: KVEntity) throws -> Data {
        let jsonData = try encoder.encode(entity)

        return switch self.cryptoProvider {
            case let .some(cryptoProvider): try cryptoProvider.encrypt(data: jsonData)
            case .none: jsonData
        }
    }

    open func decodeEntity(_ dbObject: Any) -> KVEntity? {
        do {
            guard let entity = dbObject as? DBEntity else {
                return .none
            }

            let jsonData = switch self.cryptoProvider {
                case let .some(cryptoProvider): try cryptoProvider.decrypt(data: entity.value)
                case .none: entity.value
            }

            return try self.decoder.decode(KVEntity.self, from: jsonData)
        } catch {
            logger.log("failed to decrypt entity: \(dbObject), error: \(error)")
            return .none
        }
    }
    
    open func createDbEntity(entity: KVEntity, context: NSManagedObjectContext) throws {
        let data = try encodeEntity(entity: entity)

        let newItem = DBEntity(context: context)
        newItem.key = entity.key
        newItem.value = data
    }

}
