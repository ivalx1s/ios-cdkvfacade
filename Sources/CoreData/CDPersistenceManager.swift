import CoreData

extension CDPersistenceManager {
    public enum StoringType {
        case appBundle(folder: FileManager.SearchPathDirectory)
        case sharedAppGroup(name: String)
    }
}

open class CDPersistenceManager {
    private let container: NSPersistentContainer
    internal let cryptoProvider: ICryptoProvider?

    public init(
        container: NSPersistentContainer,
        cryptoProvider: ICryptoProvider? = .none,
        storingType: StoringType = .appBundle(folder: .documentDirectory)
    ) {
        self.container = container
        self.cryptoProvider = cryptoProvider

        container.persistentStoreDescriptions.first?.url = Self.getDbStoringUrl(dbName: container.name, storingType: storingType)

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    public func eraseDb() throws {
        let dbName = self.container.name
        guard let coordinator = viewContext.persistentStoreCoordinator
        else { return }

        guard
        let store = (coordinator
            .persistentStores
            .first { $0.url?.description.contains(dbName) ?? false })
            else { return }

        guard let url = store.url
        else { return }
        try coordinator
            .destroyPersistentStore(at: url, type: .sqlite)
        _ = try coordinator.addPersistentStore(type: .sqlite, at: url)
    }

    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        let newBgContext = container.newBackgroundContext()
        newBgContext.automaticallyMergesChangesFromParent = true
        return newBgContext
    }
}

extension CDPersistenceManager {
    private static func getDbStoringUrl(dbName: String, storingType : StoringType) -> URL {
        switch storingType {
        case let .appBundle(folder):
            return Self.localStoreUrl(for: dbName, in: folder)
        case let .sharedAppGroup(name):
            return Self.sharedAppGroupStoreUrl(dbName: dbName, groupId: name)
        }
    }

    private static func localStoreUrl(for dbName: String, in folder: FileManager.SearchPathDirectory) -> URL {
        let urls = FileManager.default.urls(for: folder, in: .userDomainMask)
        guard let docURL = urls.last else {
            fatalError("Error fetching document directory")
        }
        let storeURL = docURL.appendingPathComponent("\(dbName).sqlite")
        return storeURL
    }

    private static func sharedAppGroupStoreUrl(dbName: String, groupId: String) -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId)
        storeURL = storeURL?.appendingPathComponent("\(dbName).sqlite")
        guard let storeURL else {
            fatalError("Error fetching app group directory for \(groupId)")
        }
        return storeURL
    }
}