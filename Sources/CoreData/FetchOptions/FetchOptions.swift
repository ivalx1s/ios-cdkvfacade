import Foundation

public struct CDFetchOptions {
    let offset: Int
    let limit: Int

    public init(offset: Int, limit: Int) {
        self.offset = offset
        self.limit = limit
    }
}

public enum CDSortDescriptor {
    case createDateAsc
    case createDateDesc
}

public extension CDSortDescriptor {
    var asNSSortDescriptor: NSSortDescriptor {
        switch self {
        case .createDateAsc:
            return .init(
                    key: CDConsts.createdAtFieldName,
                    ascending: true
            )
        case .createDateDesc:
            return .init(
                    key: CDConsts.createdAtFieldName,
                    ascending: false
            )
        }
    }
}