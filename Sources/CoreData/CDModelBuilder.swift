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
        case .kvWithFk: return kvWithFKEntity(name: entityName)
        case .kvPrefs: return kvEntity(name: entityName)
        }
    }

    public static func kvWithFKEntity(name: String) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = name

        var properties = Array<NSAttributeDescription>()

        let keyAttr = NSAttributeDescription()
        keyAttr.name = "key"
        keyAttr.attributeType = .stringAttributeType
        keyAttr.isOptional = false
        keyAttr.isIndexed  = true
        keyAttr.defaultValue = "undefined"
        properties.append(keyAttr)

        let fkAttr = NSAttributeDescription()
        fkAttr.name = "foreignKey"
        fkAttr.attributeType = .stringAttributeType
        fkAttr.isOptional = false
        fkAttr.isIndexed  = true
        fkAttr.defaultValue = "undefined"
        properties.append(fkAttr)

        let valueAttr = NSAttributeDescription()
        valueAttr.name = "value"
        valueAttr.attributeType = .binaryDataAttributeType
        valueAttr.isOptional = false
        valueAttr.isIndexed = false
        valueAttr.defaultValue = Data()
        properties.append(valueAttr)

        entity.properties = properties

        return entity
    }

    public static func kvEntity(name: String) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = name

        var properties = Array<NSAttributeDescription>()

        let keyAttr = NSAttributeDescription()
        keyAttr.name = "key"
        keyAttr.attributeType = .stringAttributeType
        keyAttr.isOptional = false
        keyAttr.isIndexed  = true
        keyAttr.defaultValue = "undefined"
        properties.append(keyAttr)

        let valueAttr = NSAttributeDescription()
        valueAttr.name = "value"
        valueAttr.attributeType = .binaryDataAttributeType
        valueAttr.isOptional = false
        valueAttr.isIndexed = false
        valueAttr.defaultValue = Data()
        properties.append(valueAttr)

        entity.properties = properties

        return entity
    }
}
