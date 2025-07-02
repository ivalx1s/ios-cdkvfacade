public protocol CDLogger: Sendable {
    func log(_ message: String)
}

public final class DefaultCDLogger: CDLogger {
    public static var shared: DefaultCDLogger { .init() }

    private init() {}

    public func log(_ message: String) {
        print(">>> CoreData: \(message) ")
    }
}
