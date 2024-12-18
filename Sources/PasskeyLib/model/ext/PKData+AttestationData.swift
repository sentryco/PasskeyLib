import AuthenticationServices
import CryptoKit
import SwiftCBOR
import Foundation
/**
 * Attestation Object
 * - A CBOR-encoded object that includes:
 * - Public key information
 * - RP ID (Relying Party ID)
 * - Flags indicating various properties of the authenticator
 * - Information about the authenticator used to create the passkey
 */
extension PKData {
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
   internal func getAttestationObject(publicKeySizeInBytes: Int = 64) -> Data {
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
      // Include the AAGUID by appending its raw bytes directly to authData.
      //        Swift.withUnsafeBytes(of: aaguid.uuid) { authData.append(contentsOf: $0) }
      // Append the length of the credential ID.
      authData.append(contentsOf: UInt16(credentialIDData!.count).bigEndian.bytes)
      // Append the credential ID itself.
      authData.append(contentsOf: [UInt8](credentialIDData!))
      // Encode the public key using CBOR for interoperability.
      let privKey = try! P256.Signing.PrivateKey.init(pemRepresentation: self.privateKey)
      let encodedPublicKey = CBOR.cborEncodePublicKey(privKey.publicKey, publicKeySizeInBytes: publicKeySizeInBytes)
      authData.append(contentsOf: encodedPublicKey)
      // Finally, encode the entire authentication data using CBOR to form the attestation object.
      let attestationObject = CBOR.cborEncodeAttestation(authData)
      return attestationObject
   }
}
/**
 * Extension to convert fixed-width integers to byte arrays.
 * - Description: This extension provides functionality to convert any fixed-width integer type into its byte representation.
 */
extension FixedWidthInteger {
   /**
    * Converts the integer into an array of bytes.
    * - Description: This property provides access to the raw bytes that make up the integer value in the system's native byte order.
    * - Returns: An array of UInt8 bytes representing the integer's binary data.
    */
   var bytes: [UInt8] {
      withUnsafeBytes(of: self) { Array($0) }
   }
}
