import Foundation

extension Data {
   /**
    * - Fixme: ⚠️️ add doc
    * - Parameter count: - Fixme: ⚠️️ add doc
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
   /**
    * - Fixme: ⚠️️ add doc
    */
   var hexValue: String {
      return reduce("") { $0 + String(format: "%02x", $1) }
   }
}

/// Generates a random buffer to be used as a challenge in passkey operations.
/// - Returns: A `Data` object containing random bytes.
private func generateRandomBuffer(count: Int = 32) -> Data {
   var bytes = [UInt8](repeating: 0, count: 32)
   _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
   return Data(bytes)
}
