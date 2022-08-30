import CoreData

public final class CDPersistenceManager {
    private let container: NSPersistentContainer

    public init(container: NSPersistentContainer) {
        self.container = container
        container.persistentStoreDescriptions.first?.url = Self.storeURL(for: container.name)

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        let newBgContext = container.newBackgroundContext()
        newBgContext.automaticallyMergesChangesFromParent = true
        return newBgContext
    }

    private static func storeURL(for dbName: String) -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let docURL = urls.last else {
            fatalError("Error fetching document directory")
        }
        let storeURL = docURL.appendingPathComponent("\(dbName).sqlite")
        return storeURL
    }
}
