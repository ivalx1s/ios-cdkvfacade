import Foundation
import CoreDataKVFacade

// do not move to spm
extension Contact: KVIdentifiable {
    var key: KVEntityId { self.id.description }
}


class ContactStore: CDKeyValueEntityStore<ContactEntity, Contact> {
    typealias Entity = ContactEntity
}
