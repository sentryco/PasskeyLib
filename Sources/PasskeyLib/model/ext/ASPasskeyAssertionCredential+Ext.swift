import AuthenticationServices
/**
 * Extension of `ASPasskeyAssertionCredential` to provide functionality for creating an assertion credential.
 */
extension ASPasskeyAssertionCredential {
   /**
    * - Fixme: ⚠️️ add description
    * - Parameter clientDataHash: - Fixme: ⚠️️ Add doc
    * - Returns: - Fixme: ⚠️️ Add doc
    */
   func assertionCredential(clientDataHash: Data, privateKeyStr: String) -> ASPasskeyAssertionCredential? {
      let authenticatorData: Data = authenticatorDataObj(relyingParty: relyingParty)
        // Combine the authenticator data with the client data hash to form the challenge
        let challenge = authenticatorData + clientDataHash
        // Attempt to sign the challenge with the private key
      guard let signature = signWithPrivateKey(challenge, privateKeyStr: privateKeyStr) else {
            // Return nil if the signature could not be created
            return nil
        }
        // Create an assertion credential with the necessary components
        let assertion = ASPasskeyAssertionCredential(
            userHandle: userHandle, // Identifier for the user
            relyingParty: relyingParty, // Identifier for the relying party
            signature: signature, // The digital signature over the challenge
            clientDataHash: clientDataHash, // The hash of the client data
            authenticatorData: authenticatorData, // The authenticator data used in the challenge
            credentialID: credentialID // The identifier for the credential
        )
        // Return the newly created assertion credential
        return assertion
    }
}
