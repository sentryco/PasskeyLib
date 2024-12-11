// PKCrypto.swift
import Security
import Foundation

class PKCrypto {
   static func generatePublicKey(from privateKeyData: Data) throws -> SecKey {
      var error: Unmanaged<CFError>?
      
      // Attributes for the private key
      let privateKeyAttributes: [String: Any] = [
         kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
         kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
         kSecAttrKeySizeInBits as String: 256,
         kSecAttrIsPermanent as String: false
      ]
      
      // Create the private key from data
      guard let privateKey = SecKeyCreateWithData(privateKeyData as CFData, privateKeyAttributes as CFDictionary, &error) else {
         throw error!.takeRetainedValue() as Error
      }
      
      // Extract the public key from the private key
      guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
         throw NSError(domain: NSOSStatusErrorDomain, code: 0/*errSecInvalidKey*/, userInfo: nil)
      }
      
      return publicKey
   }
}
