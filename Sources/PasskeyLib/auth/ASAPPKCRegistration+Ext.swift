import AuthenticationServices
/**
 * Type alias for simplifying the usage of a specific Apple's Authentication Services API
 */
typealias ASAPPKCRegistration = ASAuthorizationPlatformPublicKeyCredentialRegistration
/**
 * Extending the ASAuthorizationPlatformPublicKeyCredentialRegistration to handle passkey registration
 */
extension ASAuthorizationPlatformPublicKeyCredentialRegistration {
    /**
     * Handles the registration of a passkey using the provided credential data.
     * - Parameter credential: The credential received during the registration process.
     */
    func handlePasskeyRegistration(credential: ASAuthorizationPlatformPublicKeyCredentialRegistration) -> PKData? {
        // Accessing raw data components from the credential
        let rawAttestationObject = credential.rawAttestationObject
        let credentialID = credential.credentialID
        let rawClientDataJSON = credential.rawClientDataJSON
        // Encoding raw data to Base64 strings for secure transmission or storage
        let attestationObjectBase64 = rawAttestationObject?.base64EncodedString()
        let credentialIDBase64 = credentialID.base64EncodedString()
        // Uncomment the following line if client data needs to be Base64 encoded
        // let clientDataJSONBase64 = rawClientDataJSON.base64EncodedString()
        // Attempt to parse the clientDataJSON to extract useful information
       let clientDataObj: (type: String?, challenge: String?, origin: String?)
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
       
       let passkey = PKData.init(credentialID: credentialIDBase64, relyingParty: clientDataObj.origin ?? "", username: "", userHandle: "", publicKey: publicKeyBase64, privateKey: privateKeyBase64)
        return passkey
    }

}
