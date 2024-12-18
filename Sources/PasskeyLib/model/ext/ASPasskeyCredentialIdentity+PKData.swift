import AuthenticationServices
/**
 * ASPasskeyCredentialIdentity extension
 */
extension ASPasskeyCredentialIdentity {
   /**
    * Initializes a new `PKData` instance from an `ASPasskeyCredentialIdentity` object.
    * - Description: This initializer creates a new `PKData` instance using the provided `ASPasskeyCredentialIdentity`, which contains the relying party identifier, username, and user handle.
    * - Parameter asPasskeyCredentialIdentity: The `ASPasskeyCredentialIdentity` object containing the necessary data.
    */
   public var pkData: PKData {
      .init(
         relyingParty: self.relyingPartyIdentifier,
         username: self.userName,
         userHandle: self.userHandle
      )
   }
}
