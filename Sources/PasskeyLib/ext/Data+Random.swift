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
      var keyData = Data(count: count)
      let result = keyData.withUnsafeMutableBytes {
         SecRandomCopyBytes(kSecRandomDefault, count, $0.baseAddress!)
      }
      if result == errSecSuccess {
         self = keyData
      } else {
         print("Problem generating random bytes")
         return nil
      }
   }
}
/**
 * - Description: Generates a random buffer to be used as a challenge in passkey operations.
 * - Returns: A `Data` object containing random bytes.
 */
private func generateRandomBuffer(count: Int = 32) -> Data {
   var bytes = [UInt8](repeating: 0, count: 32)
   _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
   return Data(bytes)
}
