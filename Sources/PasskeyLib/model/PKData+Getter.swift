import Foundation
import CryptoKit

extension PKData {
   /**
    * Retrieves the user handle as `Data`.
    * - Description: This computed property converts the base64 URL encoded user handle string to `Data`.
    * - Returns: The user handle as `Data` or `nil` if the conversion fails.
    */
   public var userHandleData: Data? {
      .init(base64URLEncoded: self.userHandle)
   }
   /**
    * Retrieves the credential ID as `Data`.
    * - Description: This computed property converts the base64 URL encoded credential ID string to `Data`.
    * - Returns: The credential ID as `Data` or `nil` if the conversion fails.
    */
   public var credentialIDData: Data? {
      .init(base64URLEncoded: self.credentialID)
   }
   /**
    * Retrieves the private key as a base64 encoded string.
    * - Description: This computed property converts the PEM representation of the private key to a base64 encoded string.
    * - Returns: The base64 encoded string representation of the private key, or `nil` if the conversion fails.
    */
   public var privateKeyStr: String? {
      let privKey = try? P256.Signing.PrivateKey.init(pemRepresentation: self.privateKey)
      return privKey?.rawRepresentation.base64EncodedString() // der format
   }
   /**
    * Retrieves the public key as a base64 encoded string.
    * - Description: This computed property converts the PEM representation of the private key to its corresponding public key and then returns it as a base64 encoded string.
    * - Returns: The base64 encoded string representation of the public key, or `nil` if the conversion fails.
    */
   public var publicKeyStr: String? {
      let privKey = try? P256.Signing.PrivateKey.init(pemRepresentation: self.privateKey)
      let publicKey = privKey?.publicKey
      return publicKey?.rawRepresentation.base64EncodedString() // der format
   }
}
