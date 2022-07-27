import CoreData
import CoreDataKVFacade

@objc(ChatMsgEntity)
public class ChatMsgEntity: CDKeyValueWithForeignKeyEntity {
    public override static var meta: KVEntityMeta {
        .init(entityName: "ChatMsgEntity", type: .kvWithFk)
    }
}
