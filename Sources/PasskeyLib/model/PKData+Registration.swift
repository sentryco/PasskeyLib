import AuthenticationServices
/**
 * Type alias for simplifying the usage of a specific Apple's Authentication Services API
 */
typealias ASAPPKCRegistration = ASAuthorizationPlatformPublicKeyCredentialRegistration

extension PKData {
   /**
    * Handles the registration of a passkey using the provided credential data.
    * - Note: Override handlePasskeyRegistration in ASAuthorizationPlatformPublicKeyCredentialRegistration and call this to save passkey to storage
    * - Parameter credential: The credential received during the registration process.
    * - Parameter privateKeyBase64: - Fixme: ⚠️️ add doc
    * - Parameter username: - Fixme: ⚠️️ not sure if we should have this param, consider it later
    * - Returns: - Fixme: ⚠️️ add doc
    * - Fixme: ⚠️️ rename to getPKData
    * - Fixme: ⚠️️ break up this method
    */
   public func getPKData(credential: ASAuthorizationPlatformPublicKeyCredentialRegistration, privateKeyBase64: String, username: String) -> PKData? {
      // Accessing raw data components from the credential
      guard let rawAttestationObject: Data = credential.rawAttestationObject else {
         print("unable to extract raw attestation object")
         return nil
      }
      let credentialID = credential.credentialID
      let rawClientDataJSON = credential.rawClientDataJSON
      //
//      _ = {
//         let attestationObjectBase64: String = rawAttestationObject.base64EncodedString() // use url
//         let _ = attestationObjectBase64
//      }
      //
//      _ = {
//         let clientDataJSONBase64: String = rawClientDataJSON.base64EncodedString() // use url
//         let _ = clientDataJSONBase64
//      }
      // Attempt to parse the clientDataJSON to extract useful information
      guard let clientDataObj: (type: String?, challenge: String?, origin: String?)? = {
         if let clientData = try? JSONSerialization.jsonObject(with: rawClientDataJSON, options: []) as? [String: Any] {
            // Extracting the type of request (registration or authentication)
            let type = clientData["type"] as? String
            //  Extracting the cryptographic challenge to verify request authenticity
            let challenge = clientData["challenge"] as? String
            // Extracting the origin to ensure the request is coming from a trusted source
            let origin = clientData["origin"] as? String
            // Logging the extracted information
            print("Type: \(type ?? ""), Challenge: \(challenge ?? ""), Origin: \(origin ?? "")")
            return (type, challenge, origin)
         } else {
            return nil
         }
      }() else {
         print("Failed to parse client data.")
         return nil
      }
      
      // Decoding the attestation object to extract cryptographic proofs
      guard let attestationObject: AttestationObject = decodeAttestationObject(rawAttestationObject) else {
         print("Failed to decode attestation object.")
         return nil
      }
      // Extracting the public key from the attestation data
      guard let publicKey: Data  = extractPublicKey(from: attestationObject) else {
         print("Failed to get public key")
         return nil
      }
      let publicKeyBase64: String = publicKey.base64URLEncodedString()
      print("Public Key: \(publicKeyBase64)")
      // CredentialID
      let credentialIDBase64: String = credentialID.base64URLEncodedString()
      // Creating a passkey data structure to encapsulate
      return .init(
         credentialID: credentialIDBase64,
         relyingParty: clientDataObj?.origin ?? "",
         username: username, // - Fixme: ⚠️️ try to get this from rawClientDataJSON
         userHandle: credentialIDBase64,
         // publicKey: publicKeyBase64,
         privateKey: privateKeyBase64
      )
   }
}
