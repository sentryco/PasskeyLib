import AuthenticationServices
import CryptoKit
import SwiftCBOR
/**
 * Attestation Object
 * - A CBOR-encoded object that includes:
 * - Public key information
 * - RP ID (Relying Party ID)
 * - Flags indicating various properties of the authenticator
 * - Information about the authenticator used to create the passkey
 */
extension Data {
    /**
     * Creates an attestation object for authentication purposes.
     * - Description: This method constructs the attestation object needed for secure authentication by combining various elements into a single data structure.
     * - Parameters:
     *   - aaguid: The globally unique ID for the authenticator model.
     *   - relyingParty: The identifier for the relying party (e.g., a website).
     *   - credentialID: The identifier for the credential issued by the authenticator.
     *   - privateKey: The private key associated with the credential.
     * - Returns: A `Data` object representing the attestation object.
     */
    internal static func initAttestationObject(aaguid: UUID, relyingParty: String, credentialID: Data, privateKey: P256.Signing.PrivateKey) -> Data {
        var authData = Data()
        // Hash the relying party identifier to ensure privacy and integrity.
        let rpIdHash = CryptoKit.SHA256.hash(data: relyingParty.data(using: .utf8)!)
        authData.append(contentsOf: rpIdHash)
        // Set flags to indicate the data and capabilities present in the attestation.
        let flags = AuthDataFlags.at
                  | AuthDataFlags.uv
                  | AuthDataFlags.up
                  | AuthDataFlags.be
                  | AuthDataFlags.bs
        authData.append(flags)
        // Append a zeroed counter for the number of authentications (big-endian format).
        authData.append(contentsOf: UInt32(0).bigEndian.bytes)
        // Include the AAGUID and the length of the credential ID.
        authData.append(contentsOf: aaguid.data.asData)
        authData.append(contentsOf: UInt16(credentialID.count).bigEndian.bytes)
        // Append the credential ID itself.
        authData.append(contentsOf: credentialID.bytes)
        // Encode the public key using CBOR for interoperability.
        let encodedPublicKey = CBOR.cborEncodePublicKey(privateKey.publicKey)
        authData.append(contentsOf: encodedPublicKey)
        // Finally, encode the entire authentication data using CBOR to form the attestation object.
        let attestationObject = CBOR.cborEncodeAttestation(authData)
        return attestationObject
    }
}
