import AuthenticationServices
/**
 * Extension of `ASPasskeyAssertionCredential` to provide functionality for creating an assertion credential.
 */
extension PKData {
   /**
    * Generates an assertion credential using the provided client data hash and private key string.
    * **Example:**
    * ```swift
    * // Assume you have an instance of ASPasskeyAssertionCredential named `assertionCredential`
    * let clientDataHash = Data(...) // Your client data hash
    * let privateKeyStr = "MIGTAgE...AB" // Your private key string in PEM or DER format
    * if let credential = assertionCredential.getAssertionCredential(clientDataHash: clientDataHash, privateKeyStr: privateKeyStr) {
    *     // Use the `credential` as needed
    * } else {
    *     // Handle the error
    * }
    * ``` 
    * - Parameter clientDataHash: The hash of the client data used in the assertion.
    * - Parameter privateKeyStr: The private key in string format used to sign the challenge.
    * - Returns: An optional `ASPasskeyAssertionCredential` if the signature is successfully created; otherwise, `nil`.
    * - Fixme: ⚠️️ where do we get clientDataHash from? I think this is the credentialID data obj we get from external source
    */
   public func getAssertionCredential(clientDataHash: Data) -> ASPasskeyAssertionCredential? {
       // Ensure required data is available
       guard let userHandleData = self.userHandleData, let credentialIDData = self.credentialIDData else {
           print("Error: userHandleData or credentialIDData is nil")
           return nil
       }
       // Create authenticator data
       let authenticatorData = authenticatorDataObj(relyingParty: relyingParty)
       // Combine the authenticator data with the client data hash to form the challenge
       let challenge = authenticatorData + clientDataHash
       // Attempt to sign the challenge with the private key
       guard let signature = PKSigner.signWithPrivateKey(challenge, privateKeyStr: self.privateKey) else {
           print("Error: Signature could not be created")
           return nil
       }
       // Create and return the assertion credential
       return ASPasskeyAssertionCredential(
           userHandle: userHandleData, // Identifier for the user
           relyingParty: relyingParty, // Identifier for the relying party
           signature: signature, // The digital signature over the challenge
           clientDataHash: clientDataHash, // The hash of the client data
           authenticatorData: authenticatorData, // The authenticator data used in the challenge
           credentialID: credentialIDData // The identifier for the credential
       )
   }
}
