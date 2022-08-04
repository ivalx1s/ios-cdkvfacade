import Foundation

public struct CDPredicateBuilder {
    static func build(_ predicate: CDFPredicate?) -> NSPredicate? {
        guard let predicate = predicate else { return nil }
        return build(predicate: predicate)
    }

    static func build(predicate: CDFPredicate) -> NSPredicate {
        switch predicate {
        case let .not(subPredicate):
            return NSCompoundPredicate(notPredicateWithSubpredicate: build(predicate: subPredicate))

        case let .composite(logicalOperation, subPredicates):
            switch logicalOperation {
            case .and:
                return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates.map { build(predicate: $0)})
            case .or:
                return NSCompoundPredicate(orPredicateWithSubpredicates: subPredicates.map { build(predicate: $0) })
            }

        case let .key(operation):
            switch operation {
            case let .equals(key):
                return NSPredicate(format: "key == %@", key)
            case let .containedIn(keys):
                return NSPredicate(format: "key IN %@", keys)
            }

        case let .foreignKey(operation):
            switch operation {
            case let .equals(key):
                return NSPredicate(format: "foreignKey == %@", key)
            case let .containedIn(keys):
                return NSPredicate(format: "foreignKey IN %@", keys)
            }

        case let .createDate(operation):
            switch operation {
            case let .between(range):
                return NSPredicate(format: "createdAt >= %@  AND createdAt <= %@ ", argumentArray: [range.start, range.end])
            case let .greaterThan(date):
                return NSPredicate(format: "createdAt > %@", argumentArray: [date])
            case let .greaterOrEqual(date):
                return NSPredicate(format: "createdAt >= %@", argumentArray: [date])
            case let .lessThan(date):
                return NSPredicate(format: "createdAt < %@", argumentArray: [date])
            case let .lessOrEqual(date):
                return NSPredicate(format: "createdAt <= %@", argumentArray: [date])
            }
        }
    }
}
