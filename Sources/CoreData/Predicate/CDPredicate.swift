import Foundation

public enum CDDateComparisonOperation {
    case between(start: Date, end: Date)
    case greaterThan(date: Date)
    case greaterOrEqual(date: Date)
    case lessThan(date: Date)
    case lessOrEqual(date: Date)
}

public enum CDKeyComparisonOperation {
    case equals(key: String)
    case containsIn(keys: [String])
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
}