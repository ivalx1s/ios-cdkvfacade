import Foundation

public protocol ICryptoProvider {
    func encrypt(data: Data) throws -> Data
    func decrypt(data: Data) throws -> Data
}