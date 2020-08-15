//
//  Data+Extensions.swift
//  GDExtension
//
//  Created by ClaudeLi on 2019/8/20.
//

#if canImport(Foundation)
import Foundation
#endif
#if canImport(CommonCrypto)
import CommonCrypto
#endif

// MARK: - Properties
public extension Data {
    var toDictionary: [String:Any]?{
        let jsonObject = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)
        guard let dict = jsonObject as? [String: Any] else { return nil}
        return dict
    }
}
public extension Data {
    
    /// aes256 Encrypt
    ///
    /// - Parameters:
    ///   - keyData: keyData
    ///   - iv: iv
    /// - Returns: Data?
    func aes256Encrypt(keyData: Data?, iv: String?) -> Data? {
        
        if let data = keyData, data.count == kCCKeySizeAES256 {
            return aesCryptOperation(operation: CCOperation(kCCEncrypt), keyData: data, iv: iv)
        }
        
        return nil
    }
    
    /// aes256 decrypt
    ///
    /// - Parameters:
    ///   - keyData: keyData
    ///   - iv: iv
    /// - Returns: Data?
    func aes256Decrypt(keyData: Data?, iv: String?) -> Data? {
        
        if let data = keyData, data.count == kCCKeySizeAES256 {
            return aesCryptOperation(operation: CCOperation(kCCDecrypt), keyData: data, iv: iv)
        }
        
        return nil
    }
    
    /// CCCrypt Operation
    ///
    /// - Parameters:
    ///   - operation: CCOperation
    ///   - keyData: keyData
    ///   - iv: iv
    /// - Returns: Data?
    func aesCryptOperation(operation: CCOperation, keyData: Data?, iv: String?) -> Data? {
        
        let dataLength = self.count
        let ivData = iv?.data(using: .utf8)
        
        let operationSize = dataLength + kCCBlockSizeAES128
        var operationBytes = [UInt8](repeating: 0, count: operationSize)
        var numBytesEncrypted: size_t = 0
        
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        
        self.withUnsafeBytes { (encryptedBytes: UnsafePointer<UInt8>!) -> () in
            ivData?.withUnsafeBytes { (ivBytes: UnsafePointer<UInt8>!) in
                keyData?.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>!) -> () in
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCAlgorithmAES128),
                                     CCOptions(kCCOptionPKCS7Padding),
                                     keyBytes,
                                     keyData?.count ?? kCCKeySizeAES256,
                                     ivBytes,
                                     encryptedBytes,
                                     dataLength,
                                     &operationBytes,
                                     operationSize,
                                     &numBytesEncrypted)
                }
            }
        }
        
        guard status == kCCSuccess else {
            return nil
        }
        
        return Data(bytes: UnsafePointer<UInt8>(operationBytes), count: numBytesEncrypted)
    }
}
