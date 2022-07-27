import Foundation
import CoreDataKVFacade

// do not move to spm
extension ChatMsg: KVWithForeignKeyIdentifiable {
    var foreignKey: KVEntityId { self.chatId.description }
    var key: KVEntityId { self.id.description }
}


class ChatMsgStore: CDKeyValueWithForeignKeyEntityStore<ChatMsgEntity, ChatMsg> {
    typealias Entity = ChatMsgEntity
}
