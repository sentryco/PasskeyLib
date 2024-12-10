import AuthenticationServices
import SwiftCBOR

// **Attestation Object**:
//   - A CBOR-encoded object that includes:
//     - Public key information
//     - RP ID (Relying Party ID)
//     - Flags indicating various properties of the authenticator
//     - Information about the authenticator used to create the passkey

extension AttestationObject {
    // Function to decode the attestation object
    internal func decodeAttestationObject(_ attestationData: Data) -> AttestationObject? {
        // Decode the attestation object using SwiftCBOR or similar library
        let decoded = try? CBOR.decode(attestationData)
        
        // Convert the decoded CBOR to AttestationObject
        let attestationObject = AttestationObject(from: decoded)
        
        return attestationObject
    }

    // Function to extract public key from decoded attestation object
    internal func extractPublicKey(from attestationObject: AttestationObject) -> Data? {
        // Access authenticator data and extract the public key
        let authenticatorData = attestationObject.authData
        
        // The public key is typically found in the attestedCredentialData part of the authenticatorData
        let publicKey = authenticatorData.attestedCredentialData?.credentialPublicKey
        
        return publicKey
    }
}