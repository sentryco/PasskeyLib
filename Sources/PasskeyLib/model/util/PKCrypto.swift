import Security
import Foundation

class PKCrypto {
   /**
    * Generates a public key from the given private key data.
    * - Parameter privateKeyData: The data representation of the private key.
    * - Throws: An error if the private key cannot be created or the public key cannot be extracted.
    * - Returns: The generated public key as a `SecKey` object.
    */
   static func generatePublicKey(from privateKeyData: Data) throws -> SecKey {
      // Attributes for the private key
      let privateKeyAttributes: [String: Any] = [
         kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
         kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
         kSecAttrKeySizeInBits as String: 256,
         kSecAttrIsPermanent as String: false
      ]
      var error: Unmanaged<CFError>?
      // Create the private key from data
      guard let privateKey = SecKeyCreateWithData(privateKeyData as CFData, privateKeyAttributes as CFDictionary, &error) else {
          if let error = error?.takeRetainedValue() {
              throw error as Error
          } else {
              throw NSError(domain: NSOSStatusErrorDomain, code: Int(errSecParam), userInfo: nil)
          }
      }
      // Extract the public key from the private key
      guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
          throw NSError(domain: NSOSStatusErrorDomain, code: 0 /*Int(errSecInvalidKey)*/, userInfo: nil)
      }
      return publicKey
   }
}
