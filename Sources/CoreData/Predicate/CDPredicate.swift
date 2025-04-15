import Foundation

public enum CDDateComparisonOperation {
    case between(range: CDDateRange)
    case greaterThan(date: Date)
    case greaterOrEqual(date: Date)
    case lessThan(date: Date)
    case lessOrEqual(date: Date)
}

public enum CDKeyComparisonOperation {
    case equals(key: String)
    case containedIn(keys: [String])
}

public enum CDLogicalOperation: String {
    case and
    case or
}

public indirect enum CDFPredicate {
    case not(CDFPredicate)
    case composite(operation: CDLogicalOperation, predicates: [CDFPredicate])
    case createDate(operation: CDDateComparisonOperation)
    case key(operation: CDKeyComparisonOperation)
    case foreignKey(operation: CDKeyComparisonOperation)

    func containsOnly(types: [PType]) -> Bool {
        has(predicate: self, types: types)
    }

    private func has(predicate: CDFPredicate, types: [PType]) -> Bool {
        switch predicate {
        case let .not(predicate): return has(predicate: predicate, types: types)
        case let .composite(_, predicates): return predicates.contains { has(predicate: $0, types: types)}
        case .key,
             .foreignKey,
             .createDate:
            return types.contains(self.type)
        }
    }

    var type: PType {
        switch self {
        case .not: return .compound
        case .composite: return .compound
        case .key: return .key
        case .foreignKey: return .foreignKey
        case .createDate: return .createDate
        }
    }

    public enum PType {
        case compound
        case key
        case foreignKey
        case createDate
    }
}

extension CDFPredicate.PType: Sendable { }
