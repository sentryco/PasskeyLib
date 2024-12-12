import AuthenticationServices

extension PKData {
   /**
    * - Fixme: ⚠️️ Add doc
    * - Parameter clientDataHash: - Fixme: ⚠️️ Add doc
    * - Returns: - Fixme: ⚠️️ Add doc
    */
   @available(iOS 18.0, macOS 15.0, *) // - Fixme: ⚠️️ Move this inside as a guard?
   public func getRegistrationCredential(clientDataHash: Data) -> ASPasskeyRegistrationCredential? {
      guard let credentialIDData = self.credentialIDData else {
         Swift.print("Err credentialIDData")
         return nil
      }
      return .init(
         relyingParty: relyingParty,
         clientDataHash: clientDataHash,
         credentialID: credentialIDData,
         attestationObject: getAttestationObject(),
         extensionOutput: nil
      )
   }
}
