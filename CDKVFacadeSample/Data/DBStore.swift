import Foundation


protocol IDBStore {
    var contacts: ContactStore { get }
    var chatMsgs: ChatMsgStore { get }
    var userPrefs: UserPrefsStore { get }
}

class DBStore: IDBStore {
    let contacts: ContactStore
    let chatMsgs: ChatMsgStore
    let userPrefs: UserPrefsStore

    init(
            contactsStore: ContactStore,
            chatMsgs: ChatMsgStore,
            userPrefs: UserPrefsStore
    ) {
        self.contacts = contactsStore
        self.chatMsgs = chatMsgs
        self.userPrefs = userPrefs
    }
}
