import CoreData

public enum CDModelBuilder {
    public static func buildCoreDataModel(_ metas: [KVEntityMeta]) -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        model.entities = metas.map(buildEntity)
        return model
    }

    public static func buildEntity(_ entity: KVEntityMeta) -> NSEntityDescription {
        let entityName = entity.entityName
        switch entity.type {
        case .kv: return kvEntity(name: entityName)
        case .kvDated: return kvDatedEntity(name: entityName)
        case .kvWithFk: return kvWithFKEntity(name: entityName)
        case .kvWithFkDated: return kvWithFkDatedEntity(name: entityName)
        case .kvPrefs: return kvEntity(name: entityName)
        }
    }

    public static func kvWithFKEntity(name: String) -> NSEntityDescription {
        let entity = entity(for: name)

        var properties = Array<NSAttributeDescription>()
        properties.append(keyAttr)
        properties.append(fkAttr)
        properties.append(valueAttr)
        entity.properties = properties

        return entity
    }

    public static func kvWithFkDatedEntity(name: String) -> NSEntityDescription {
        let entity = entity(for: name)

        var properties = Array<NSAttributeDescription>()
        properties.append(keyAttr)
        properties.append(fkAttr)
        properties.append(valueAttr)
        properties.append(createDateAttr)
        entity.properties = properties

        return entity
    }

    public static func kvEntity(name: String) -> NSEntityDescription {
        let entity = entity(for: name)

        var properties = Array<NSAttributeDescription>()
        properties.append(keyAttr)
        properties.append(valueAttr)
        entity.properties = properties

        return entity
    }

    public static func kvDatedEntity(name: String) -> NSEntityDescription {
        let entity = entity(for: name)
        var properties = Array<NSAttributeDescription>()
        properties.append(keyAttr)
        properties.append(valueAttr)
        properties.append(createDateAttr)
        entity.properties = properties

        return entity
    }

    private static func entity(for name: String) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = name
        return entity
    }

    private static var keyAttr: NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = "key"
        attr.attributeType = .stringAttributeType
        attr.isOptional = false
        attr.isIndexed  = true
        attr.defaultValue = "undefined"
        return attr
    }

    private static var valueAttr: NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = "value"
        attr.attributeType = .binaryDataAttributeType
        attr.isOptional = false
        attr.isIndexed = false
        attr.defaultValue = Data()
        return attr
    }

    private static var fkAttr: NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = "foreignKey"
        attr.attributeType = .stringAttributeType
        attr.isOptional = false
        attr.isIndexed  = true
        attr.defaultValue = "undefined"
        return attr
    }

    private static var createDateAttr: NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = "createdAt"
        attr.attributeType = .dateAttributeType
        attr.isOptional = false
        attr.isIndexed  = true
        attr.defaultValue = Date.now
        return attr
    }
}
