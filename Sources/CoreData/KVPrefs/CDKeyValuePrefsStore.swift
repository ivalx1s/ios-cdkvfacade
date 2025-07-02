import Foundation
import CoreData

open class CDKeyValuePrefsStore: KeyValuePrefsStore {
    public typealias KVEntity = AnyKVPref

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

    open func read<Model>(from entity: CDKeyValueEntity.Type) throws -> Model? where Model: KVEntity {

        logger.log("***** read started: \(entity.self)")

        let entity: Model? = try viewContext
                .fetch(entity.fetchRequest(predicate: CDFPredicate.key(operation: .equals(key: Model.key))))
                .compactMap {
                    let model: Model? = decodeEntity($0)
                    return model
                }
                .first

        logger.log("***** read ended: \(entity.self) \(entity != nil)")

        return entity
    }

    open func upsert<Model>(to entity: CDKeyValueEntity.Type, _ item: Model) throws where Model: KVEntity {

        logger.log("***** upsert start: \(entity.self)")

        let context = try bgContext
        try context.execute(entity.deleteRequest(predicate: CDFPredicate.key(operation: .equals(key: Model.key))))
        try createDbEntity(entity: entity, item: item, context: context)

        logger.log("***** upsert end: \(entity.self)")
    }

    open func delete(by key: KVEntityId, from entity: CDKeyValueEntity.Type) throws {
        logger.log("***** delete by key \(key) start: \(entity.self)")
        try bgContext.execute(entity.deleteRequest(predicate: CDFPredicate.key(operation: .equals(key: key))))
        logger.log("***** delete by key \(key) end: \(entity.self)")
    }

    private func createDbEntity<Model>(entity: CDKeyValueEntity.Type, item: Model, context: NSManagedObjectContext) throws where Model: KVEntity {
        guard let data = try encodeEntity(item: item) else {
            throw CDError.failedToEncodeEntity
        }

        let newItem = entity.init(context: context)
        newItem.key = Model.key
        newItem.value = data

        try context.save()
    }

    private final func encodeEntity<Model>(item: Model) throws -> Data? where Model: Encodable {
        let jsonData = try encoder.encode(item)

        return switch self.cryptoProvider {
            case let .some(cryptoProvider): try cryptoProvider.encrypt(data: jsonData)
            case .none: jsonData
        }
    }

    private final func decodeEntity<Model>(_ obj: Any) -> Model? where Model: Decodable {
        do {
            guard let entity = obj as? CDKeyValueEntity else {
                return .none
            }

            let jsonData = switch self.cryptoProvider {
                case let .some(cryptoProvider): try cryptoProvider.decrypt(data: entity.value)
                case .none: entity.value
            }

            return try self.decoder.decode(Model.self, from: jsonData)
        } catch {
            logger.log("failed to decode entity:\(obj), error: \(error)")
            return .none
        }
    }
}
