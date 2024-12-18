import AuthenticationServices
/**
 * ASPasskeyRegistrationCredential
 */
extension PKData {
   /**
    * Creates an ASPasskeyRegistrationCredential object for passkey registration.
    * - Parameter clientDataHash: A SHA-256 hash of the client data JSON that contains information about the registration operation, including the challenge from the server.
    * - Returns: An ASPasskeyRegistrationCredential object containing the registration data, or nil if the credential ID data is missing.
    */
   @available(iOS 18.0, macOS 15.0, *) // - Fixme: ⚠️️ Move this inside as a guard?
   public func getRegistrationCredential(clientDataHash: Data) -> ASPasskeyRegistrationCredential? {
      guard let credentialIDData = self.credentialIDData else {
         Swift.print("Err credentialIDData")
         return nil
      }
      return ASPasskeyRegistrationCredential(
         relyingParty: relyingParty,
         clientDataHash: clientDataHash,
         credentialID: credentialIDData,
         attestationObject: getAttestationObject()// ,
         // extensionOutput: nil
      )
   }
}
