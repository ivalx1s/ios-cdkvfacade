import Foundation

struct UserPrefs: Codable, Equatable {
    var notificationsAllowed: Bool
    var appOnboarded: Bool

    static let defaultValue: UserPrefs = .init(notificationsAllowed: false, appOnboarded: false)
}