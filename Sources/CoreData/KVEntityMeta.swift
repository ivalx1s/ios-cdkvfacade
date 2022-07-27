public struct KVEntityMeta {
    public let entityName: String
    public let type: KVStoreType
    
    public init(
        entityName: String,
        type: KVStoreType
    ) {
        self.entityName = entityName
        self.type = type
    }
}
