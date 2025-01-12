import CryptoKit
import Foundation
/**
 * Data+Hex
 */
extension Data {
   /**
    * - Description: Initializes a Data object from a hexadecimal string.
    * - Returns: A Data object containing the decoded bytes, or nil if the string is not a valid hexadecimal string.
    * - Parameter hexString: A hexadecimal string to decode.
    */
   public init?(hexString: String) {
      // Ensure the hex string has an even number of characters
      guard hexString.count % 2 == 0 else { return nil }
      var data = Data(capacity: hexString.count / 2)
      var index = hexString.startIndex
      // Iterate over every pair of characters in the hex string
      for _ in 0..<(hexString.count / 2) {
         let nextIndex = hexString.index(index, offsetBy: 2)
         let byteString = hexString[index..<nextIndex]
         // Convert the pair of characters into a byte
         guard let num = UInt8(byteString, radix: 16) else { return nil }
         data.append(num)
         index = nextIndex
      }
      self = data
   }
   /**
    * - Description: Converts a Data object to a hexadecimal string.
    * - Returns: A hexadecimal string representation of the Data object.
    */
   public func toHexString() -> String {
      return map { String(format: "%02x", $0) }.joined()
   }
   /**
    * - Description: Decodes a hexadecimal string into `Data`.
    * - Returns: A `Data` object containing the decoded bytes.
    * - Parameter hex: The hexadecimal string to decode.
    * - Throws: An error if the string contains non-hexadecimal characters or has an odd length.
    */
   public static func decodeHex(_ hex: String) throws -> Data {
      // Check if the hex string has an even length
      guard hex.count % 2 == 0 else {
         throw DecodingError.oddLengthString
      }
      
      var data = Data(capacity: hex.count / 2)
      
      // Iterate over the hex string in steps of 2 characters
      for i in stride(from: 0, to: hex.count, by: 2) {
         let startIndex = hex.index(hex.startIndex, offsetBy: i)
         let endIndex = hex.index(startIndex, offsetBy: 2)
         let byteString = hex[startIndex..<endIndex]
         
         // Convert the 2-character string into a byte
         guard let byte = UInt8(byteString, radix: 16) else {
            throw DecodingError.invalidHexCharacter
         }
         data.append(byte)
      }
      
      return data
   }
   /**
    * - Description: Represents errors that can occur during hexadecimal decoding.
    */
   enum DecodingError: Error {
      case oddLengthString
      case invalidHexCharacter
   }
}
