import Foundation

struct ChatMsg: Codable {
    let id: Int
    let chatId: Int
    let msg: String
    let createDate: Date
}