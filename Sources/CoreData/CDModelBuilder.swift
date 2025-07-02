import CoreData

public enum CDModelBuilder {
    public static func buildCoreDataModel(_ metas: [KVEntityMeta]) -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        model.entities = metas.map(buildEntity)
        return model
    }
}

// entity builders
extension CDModelBuilder {
    public static func buildEntity(_ entity: KVEntityMeta) -> NSEntityDescription {
        let entityName = entity.entityName
        switch entity.type {
            case .kv: return kvEntity(name: entityName)
            case .kvDated: return kvDatedEntity(name: entityName)
            case .kvWithFk: return kvWithFKEntity(name: entityName)
            case .kvWithFkDated: return kvWithFkDatedEntity(name: entityName)
            case .kvPrefs: return kvEntity(name: entityName)
            case .kvPrefsDated: return kvDatedEntity(name: entityName)
        }
    }

    public static func kvEntity(name: String) -> NSEntityDescription {
        entity(
            for: name,
            attributes: [
                keyAttr,
                valueAttr,
            ],
            indexes: [
                buildIndex(with: "\(name)_key_index", for: keyAttr),
            ]
        )
    }

    public static func kvDatedEntity(name: String) -> NSEntityDescription {
        entity(
            for: name,
            attributes: [
                keyAttr,
                valueAttr,
                createDateAttr,
            ],
            indexes: [
                buildIndex(with: "\(name)_key_index", for: keyAttr),
                buildIndex(with: "\(name)_date_index", for: createDateAttr),
            ]
        )
    }

    public static func kvWithFKEntity(name: String) -> NSEntityDescription {
        entity(
            for: name,
            attributes: [
                keyAttr,
                fkAttr,
                valueAttr,
            ],
            indexes: [
                buildIndex(with: "\(name)_key_index", for: keyAttr),
                buildIndex(with: "\(name)_fk_index", for: fkAttr),
            ]
        )
    }

    public static func kvWithFkDatedEntity(name: String) -> NSEntityDescription {
        entity(
            for: name,
            attributes: [
                keyAttr,
                fkAttr,
                valueAttr,
                createDateAttr,
            ],
            indexes: [
                buildIndex(with: "\(name)_key_index", for: keyAttr),
                buildIndex(with: "\(name)_fk_index", for: fkAttr),
                buildIndex(with: "\(name)_date_index", for: createDateAttr),
            ]
        )
    }

    private static func entity(
        for name: String,
        attributes: [NSAttributeDescription],
        indexes: [NSFetchIndexDescription] = []
    ) -> NSEntityDescription {
        let entity = NSEntityDescription()

        entity.name = name
        entity.managedObjectClassName = name

        entity.properties = attributes

        entity.indexes = indexes

        return entity
    }


}

// entity fields builders
extension CDModelBuilder {
    private static var keyAttr: NSAttributeDescription {
        buildAttr(
            name: CDConsts.keyFieldName,
            type: .stringAttributeType,
            defaultValue: CDConsts.keyDefaultValue
        )
    }

    private static var valueAttr: NSAttributeDescription {
        buildAttr(
            name: CDConsts.valueFieldName,
            type: .binaryDataAttributeType,
            defaultValue: CDConsts.valueDefaultValue
        )
    }

    private static var fkAttr: NSAttributeDescription {
        buildAttr(
            name: CDConsts.foreignKeyFieldName,
            type: .stringAttributeType,
            defaultValue: CDConsts.keyDefaultValue
        )
    }

    private static var createDateAttr: NSAttributeDescription {
        buildAttr(
            name: CDConsts.createdAtFieldName,
            type: .dateAttributeType,
            defaultValue: Date.distantPast
        )
    }

    private static func buildAttr(
        name: String,
        type: NSAttributeType,
        isOptional: Bool = false,
        defaultValue: Any? = nil
    ) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = type
        attr.isOptional = isOptional
        attr.defaultValue = defaultValue
        return attr
    }
}

// idx builder
extension CDModelBuilder {
    private static func buildIndex(
        with name: String,
        for attr: NSAttributeDescription,
        indexType: NSFetchIndexElementType = .binary
    ) -> NSFetchIndexDescription {
        NSFetchIndexDescription(name: name, elements: [
            NSFetchIndexElementDescription(property: attr, collationType: indexType)
        ])
    }
}
