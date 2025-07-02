enum CDError: Error {
    case predicateNotAvailableForDbEntity(availableTypes: [CDFPredicate.PType])
    case failedToEncodeEntity
    case failedToDecodeEntity
    case noPersistenceManager
}
