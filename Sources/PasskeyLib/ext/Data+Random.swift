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
/**
 * - Description: Generates a random buffer to be used as a challenge in passkey operations.
 * - Returns: A `Data` object containing random bytes.
 */
/**
 * Generates a random buffer to be used as a challenge in passkey operations.
 * - Parameter count: The number of random bytes to generate. Default is 32.
 * - Returns: A `Data` object containing random bytes. Returns an empty `Data` if random generation fails.
 */
private func generateRandomBuffer(count: Int = 32) -> Data {
    guard let randomData = Data(random: count) else {
        print("Problem generating random bytes")
        return Data()
    }
    return randomData
}
