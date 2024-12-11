//
//  Data+EncodingExtensions.swift
//
//
//

import CryptoKit
import Foundation

extension Data {
   public init?(hexString: String) {
      let len = hexString.count / 2
      var data = Data(capacity: len)
      for i in 0..<len {
         let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
         let k = hexString.index(j, offsetBy: 2)
         let bytes = hexString[j..<k]
         if var num = UInt8(bytes, radix: 16) {
            data.append(&num, count: 1)
         } else {
            return nil
         }
      }
      self = data
   }
   
   public func toHexString() -> String {
      return map { String(format: "%02x", $0) }.joined()
   }
   
   /// Decodes a hexadecimal string into `Data`.
   /// - Parameter hex: The hexadecimal string to decode.
   /// - Throws: An error if the string contains non-hexadecimal characters or has an odd length.
   /// - Returns: A `Data` object containing the decoded bytes.
   public static func decodeHex(_ hex: String) throws -> Data {
      guard hex.count % 2 == 0 else {
         throw DecodingError.oddLengthString
      }
      
      var data = Data()
      var bytePair = ""
      
      for char in hex {
         bytePair += String(char)
         if bytePair.count == 2 {
            guard let byte = UInt8(bytePair, radix: 16) else {
               throw DecodingError.invalidHexCharacter
            }
            data.append(byte)
            bytePair = ""
         }
      }
      
      return data
   }
   
   enum DecodingError: Error {
      case oddLengthString
      case invalidHexCharacter
   }
}
