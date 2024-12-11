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
    * - Returns: - Fixme: ⚠️️ add doc
    * - Fixme: ⚠️️ rename to getPKData
    */
   public func getPKData(credential: ASAuthorizationPlatformPublicKeyCredentialRegistration, privateKeyBase64: String) -> PKData? {
      // Accessing raw data components from the credential
      guard let rawAttestationObject = credential.rawAttestationObject else {
         print("unable to extract raw attestation object")
         return nil
      }
      let credentialID = credential.credentialID
      let rawClientDataJSON = credential.rawClientDataJSON
      // Encoding raw data to Base64 strings for secure transmission or storage
      // let attestationObjectBase64 = rawAttestationObject.base64EncodedString()
      let credentialIDBase64 = credentialID.base64EncodedString()
      // Uncomment the following line if client data needs to be Base64 encoded
      // let clientDataJSONBase64 = rawClientDataJSON.base64EncodedString()
      // Attempt to parse the clientDataJSON to extract useful information
      var clientDataObj: (type: String?, challenge: String?, origin: String?)? = nil
      if let clientData = try? JSONSerialization.jsonObject(with: rawClientDataJSON, options: []) as? [String: Any] {
         // Extracting the type of request (registration or authentication)
         let type = clientData["type"] as? String
         //  Extracting the cryptographic challenge to verify request authenticity
         let challenge = clientData["challenge"] as? String
         // Extracting the origin to ensure the request is coming from a trusted source
         let origin = clientData["origin"] as? String
         // Logging the extracted information
         print("Type: \(type ?? ""), Challenge: \(challenge ?? ""), Origin: \(origin ?? "")")
         clientDataObj = (type, challenge, origin)
      }
      // Decoding the attestation object to extract cryptographic proofs
      guard let attestationObject = decodeAttestationObject(rawAttestationObject) else {
         print("Failed to decode attestation object.")
         return nil
      }
      // Extracting the public key from the attestation data
      guard let publicKey = extractPublicKey(from: attestationObject) else {
         print("Failed to get public key")
         return nil
      }
      let publicKeyBase64 = publicKey.base64EncodedString()
      print("Public Key: \(publicKeyBase64)")
      // Creating a passkey data structure to encapsulate
      
      return .init(
         credentialID: credentialIDBase64,
         relyingParty: clientDataObj?.origin ?? "",
         username: "",
         userHandle: "",
         publicKey: publicKeyBase64,
         privateKey: privateKeyBase64
      )
   }

}
