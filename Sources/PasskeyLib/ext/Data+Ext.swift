import Foundation
/**
 * Data ext
 */
extension Data {
   /**
    * - Description: Returns an array of bytes from the Data object.
    * - Returns: An array of bytes.
    */
   var bytes: [UInt8] {
      return [UInt8](self)
   }
}
