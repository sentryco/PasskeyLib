import Foundation
import CryptoKit

extension PKData {
   /**
    * Retrieves the user handle as `Data`.
    * - Description: Converts the base64 URL encoded user handle string to `Data`.
    * - Returns: The user handle as `Data` or `nil` if the conversion fails.
    */
   public var userHandleData: Data? {
       Data(base64URLEncoded: self.userHandle)
   }
   /**
    * Retrieves the credential ID as `Data`.
    * - Description: Converts the base64 URL encoded credential ID string to `Data`.
    * - Returns: The credential ID as `Data` or `nil` if the conversion fails.
    */
   public var credentialIDData: Data? {
       Data(base64URLEncoded: self.credentialID)
   }
   /**
    * Retrieves the private key as a base64 encoded string.
    * - Description: Converts the PEM representation of the private key to a base64 encoded string.
    * - Returns: The base64 encoded string representation of the private key, or `nil` if the conversion fails.
    */
   public var privateKeyStr: String? {
       parsedPrivateKey?.rawRepresentation.base64EncodedString()
   }
   /**
    * Retrieves the public key as a base64 encoded string.
    * - Description: Converts the PEM representation of the private key to its corresponding public key, and returns it as a base64 encoded string.
    * - Returns: The base64 encoded string representation of the public key, or `nil` if the conversion fails.
    */
   public var publicKeyStr: String? {
       parsedPrivateKey?.publicKey.rawRepresentation.base64EncodedString()
   }
   /// Parsed private key from PEM representation
   private var parsedPrivateKey: P256.Signing.PrivateKey? {
       try? P256.Signing.PrivateKey(pemRepresentation: self.privateKey)
   }
}
