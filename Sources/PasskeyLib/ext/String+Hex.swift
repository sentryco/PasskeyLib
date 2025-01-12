import Foundation
/**
 * String extension to convert hex string to bytes and Data.
 */
extension String {
   /**
    * - Description: Converts a string to an array of hexadecimal bytes.
    * - Returns: An array of UInt8 bytes represented by the hex string.
    */
   public var hex: [UInt8] {
      stride(from: 0, to: self.count, by: 2).compactMap { index in
          let start = self.index(self.startIndex, offsetBy: index)
          let end = self.index(start, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
          let byteString = self[start..<end]
          return UInt8(byteString, radix: 16)
      }
   }
   /**
    * - Description: Converts a string to a Data object.
    * - Returns: A Data object containing the hexadecimal bytes.
    */
   public var hexData: Data {
      return Data(hex)
   }
}
