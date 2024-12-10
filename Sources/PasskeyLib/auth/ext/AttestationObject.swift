import AuthenticationServices
import SwiftCBOR
/**
 * Function to decode the attestation object
 * - Parameter attestationData: The data representing the attestation object to decode.
 * - Returns: An optional `AttestationObject` if decoding is successful, otherwise `nil`.
 */
internal func decodeAttestationObject(_ attestationData: Data) -> AttestationObject? {
   // Decode the attestation object using SwiftCBOR or similar library
   let decoded = try? CBOR.decode(attestationData)
   // Convert the decoded CBOR to AttestationObject
   let attestationObject = AttestationObject(from: decoded)
   return attestationObject
}
/**
 * Function to extract public key from decoded attestation object
 * - Parameter attestationObject: The `AttestationObject` from which to extract the public key.
 * - Returns: An optional `Data` object containing the public key if extraction is successful, otherwise `nil`.
 */
internal func extractPublicKey(from attestationObject: AttestationObject) -> Data? {
   // Access authenticator data and extract the public key
   let authenticatorData = attestationObject.authData
   // The public key is typically found in the attestedCredentialData part of the authenticatorData
   let publicKey = authenticatorData.attestedCredentialData?.credentialPublicKey
   return publicKey
}
