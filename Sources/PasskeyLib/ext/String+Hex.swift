import Foundation
/**
 * String ext
 */
extension String {
   /**
    * - Description: Converts a string to a sequence of hexadecimal bytes.
    * - Returns: A sequence of hexadecimal bytes.
    */
   public var hex: some Sequence<UInt8> {
      self[...].hex
   }
   /**
    * - Description: Converts a string to a Data object.
    * - Returns: A Data object containing the hexadecimal bytes.
    */
   public var hexData: Data {
      return Data(hex)
   }
}
/**
 * Substring ext
 */
extension Substring {
   /**
    * - Description: Converts a substring to a sequence of hexadecimal bytes.
    * - Returns: A sequence of hexadecimal bytes.
    */
   public var hex: some Sequence<UInt8> {
      sequence(
         state: self,
         next: { remainder in
            guard remainder.count > 2 else { return nil }
            let nextTwo = remainder.prefix(2)
            remainder.removeFirst(2)
            return UInt8(nextTwo, radix: 16)
         })
   }
}
