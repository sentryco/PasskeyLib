import AuthenticationServices
import CryptoKit
import Foundation
import Security
/** 
 * Extension of `PKData` to include initialization and utility methods related to passkey registration.
 */
extension PKData {
   /**
    * Initializes a `NewPasskey` object using registration parameters.
    * This method checks if the required algorithm is supported before proceeding.
    * - Parameter params: The registration parameters including user and relying party identifiers.
    * - Throws: `PasskeyRegistrationError.unsupportedAlgorithm` if ES256 is not supported.
    * - Returns: A `NewPasskey` instance initialized with the provided parameters.
    * - Fixme: ⚠️️ add example code for this
    */
   public init(with params: PKRegistration) throws {
      /**
       * Ensure the ES256 algorithm is supported
       */
      guard params.supportedAlgorithms.contains(.ES256) else {
         print("Supported algorithms do not include ES256, cancelling")
         throw PKRegistrationError.unsupportedAlgorithm
      }
      self = .init(
         relyingParty: params.identity.relyingPartyIdentifier,
         username: params.identity.userName,
         userHandle: params.identity.userHandle)
   }
   /**
    * Initializes a new `PKData` instance with the specified parameters.
    *
    * This initializer creates a new passkey by generating a private key and credential ID,
    * and sets up the passkey data for the specified relying party and user.
    *
    * - Parameters:
    *   - relyingParty: The identifier of the relying party for whom the passkey is being created.
    *   - username: The username associated with the passkey.
    *   - userHandle: A unique identifier for the user, typically used by the relying party.
    *
    * - Example:
    *   ```swift
    *   // Example usage of PKData initializer
    *   let userHandle = UUID().uuidString.data(using: .utf8)!
    *   let pkData = PKData(
    *       relyingParty: "example.com",
    *       username: "alice",
    *       userHandle: userHandle
    *   )
    *   ```
    */
   public init(relyingParty: String, username: String, userHandle: Data) {
      // Initialize a new private key for signing
      let privateKey = P256.Signing.PrivateKey()
      // Define the size of the credential ID in bytes
      let credentialIDSizeInBytes = 32
      // Generate a random credential ID or use an empty data if generation fails
      let credentialID = Data(random: credentialIDSizeInBytes) ?? .init()
      // Initialize PKData with the generated key and credential ID
      self = PKData(
         credentialID: credentialID.base64EncodedString(),
         relyingParty: relyingParty,
         username: username,
         userHandle: userHandle.base64EncodedString(),
         privateKey: privateKey.pemRepresentation
      )
   }
}
