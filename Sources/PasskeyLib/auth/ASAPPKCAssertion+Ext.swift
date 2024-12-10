import AuthenticationServices
/** 
 * Extension for `ASAuthorizationPlatformPublicKeyCredentialAssertion` to handle the response of a passkey authentication or registration.
 * - Description: This extension provides a method to parse the `clientDataJSON` from a `PublicKeyCredential` received during authentication or registration processes.
 * - Note: The `clientDataJSON` includes critical information such as the type of operation, the cryptographic challenge, and the origin of the request.
 * - Note: When you receive a `PublicKeyCredential` during authentication or registration, you can access and parse `clientDataJSON` as follows:
 * 1. **Type**:  - Indicates the type of operation being performed. It can be either `"webauthn.create"` for registration or `"webauthn.get"` for authentication.
 * 2. **Challenge**:  - A base64url encoded version of the cryptographic challenge sent from the relying party (RP) during the request. This challenge ensures that responses are tied to a specific authentication request, preventing replay attacks.
 * 3. **Origin**:  - The fully qualified origin (protocol, domain, and port) of the RP that initiated the request. This is critical for ensuring that the response is valid for the expected domain, helping to prevent phishing attacks.
 * `challenge`: This contains the challenge value used for authentication. It's a critical component in the WebAuthn protocol, allowing the server to verify the authenticity of the passkey.
 */
extension ASAuthorizationPlatformPublicKeyCredentialAssertion {
    /** 
     * Handles the response from a passkey authentication or registration request.
     * - Description: This method extracts and prints the type of WebAuthn operation, the cryptographic challenge, and the origin of the request from the `clientDataJSON`.
     * - Note: These elements are essential for validating the authenticity and integrity of the passkey operation.
     * - Parameter credential: The `ASAuthorizationPlatformPublicKeyCredentialAssertion` containing the response data.
     */
    func handlePasskeyResponse(credential: ASAuthorizationPlatformPublicKeyCredentialAssertion) {
        let clientDataJSON = credential.rawClientDataJSON
        // Convert Data to String
        if let clientDataString = String(data: clientDataJSON, encoding: .utf8) {
            // Parse JSON
            if let jsonData = clientDataString.data(using: .utf8) {
                do {
                    if let clientDataDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        // The type of the request (e.g., "webauthn.create" for registration)
                        let type = clientDataDict["type"] as? String
                        // The cryptographic challenge sent by the server
                        let challenge = clientDataDict["challenge"] as? String
                        // The origin of the request (e.g., the domain of the website)
                        let origin = clientDataDict["origin"] as? String
                        print("Type: \(type ?? "")")
                        print("Challenge: \(challenge ?? "")")
                        print("Origin: \(origin ?? "")")
                    }
                } catch {
                    print("Error parsing clientDataJSON: \(error)")
                }
            }
        }
    }
}
