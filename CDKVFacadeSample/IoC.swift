import Foundation
import CoreData
import CoreDataKVFacade

struct IoC {
    static let persistenceContainer: NSPersistentCloudKitContainer = .init(
            name: "DB_5",
            managedObjectModel: CDModelBuilder.buildCoreDataModel([
                ContactEntity.meta,
                ChatMsgEntity.meta,
                UserPrefsEntity.meta
            ])
    )

    static let dbManager: CDPersistenceManager = .init(
            container: persistenceContainer
    )

    static let DBStore: DBStore = .init(
            contactsStore: ContactStore(persistenceController: dbManager),
            chatMsgs: ChatMsgStore(persistenceController: dbManager),
            userPrefs: UserPrefsStore(persistenceController: dbManager)
    )
}
