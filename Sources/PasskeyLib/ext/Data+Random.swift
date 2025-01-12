import Foundation
/**
 * Data+Random
 */
extension Data {
   /**
    * - Description: Initializes a Data object with random bytes.
    * - Returns: A Data object containing random bytes, or nil if the random generation fails.
    * - Parameter count: The number of bytes to generate.
    */
   init?(random count: Int) {
       var bytes = [UInt8](repeating: 0, count: count)
       let result = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
       if result == errSecSuccess {
           self = Data(bytes)
       } else {
           print("Problem generating random bytes: \(result)")
           return nil
       }
   }
}
