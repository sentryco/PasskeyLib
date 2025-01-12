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
   /// Errors that can be thrown when creating an attestation object.
   enum AttestationObjectError: Error {
      case invalidRelyingPartyString
      case invalidCredentialIDData
   }
/**
* Creates an attestation object for authentication purposes.
* - Description: This method constructs the attestation object needed for secure authentication by combining various elements into a single data structure.
* - Parameter publicKeySizeInBytes: The size in bytes of the public key. Default is 64 bytes.
* - Returns: A `Data` object representing the attestation object.
*/
internal func getAttestationObject(publicKeySizeInBytes: Int = 64) throws -> Data {
   // Verify relying party string is valid
   guard let rpIdData = relyingParty.data(using: .utf8) else {
      throw AttestationObjectError.invalidRelyingPartyString
   }
   
   let rpIdHash = CryptoKit.SHA256.hash(data: rpIdData)
   let _ = rpIdHash

   // Verify credential ID data is available
   guard let credentialIDData = credentialIDData else {
      throw AttestationObjectError.invalidCredentialIDData
   }

   // Obtain the public key from the private key
   let privateKey = try P256.Signing.PrivateKey(pemRepresentation: self.privateKey)
   let publicKey = privateKey.publicKey

   // Encode the public key using CBOR for interoperability
   let encodedPublicKey = try CBOR.cborEncodePublicKey(publicKey, publicKeySizeInBytes: publicKeySizeInBytes)

   // Create the attested credential data
   let attestedCredentialData = AttestedCredentialData(
      aaguid: AAGUID.defaultAAGUID, // Use default AAGUID
      credentialID: [UInt8](credentialIDData),
      publicKey: encodedPublicKey.bytes
   )

   // Set flags to indicate the data and capabilities present in the attestation
   let flags: AuthenticatorFlags = [.attestedData, .userVerified, .userPresent, .backupEligibility, .backupState]

   // Initialize counter to zero
   let counter: UInt32 = 0

   // Create the authenticator data
   let authenticatorData = AuthenticatorData(
      relyingPartyID: relyingParty,
      flags: flags,
      counter: counter,
      attestedData: attestedCredentialData,
      extData: nil
   )

   // Get the byte representation of the authenticator data
   let authDataBytes = authenticatorData.byteArrayRepresentation()

   // Encode the entire authentication data using CBOR to form the attestation object
   let attestationObject = CBOR.cborEncodeAttestation(Data(authDataBytes))
   return attestationObject
}
}
/**
 * Extension to convert fixed-width integers to byte arrays.
 * - Description: This extension provides functionality to convert any fixed-width integer type into its byte representation.
 */
extension FixedWidthInteger {
   /**
    * Converts the integer into an array of bytes in big-endian order.
    * - Description: This property provides access to the raw bytes that make up the integer value in big-endian byte order.
    * - Returns: An array of UInt8 bytes representing the integer's binary data.
    */
   var bytes: [UInt8] {
      withUnsafeBytes(of: self.bigEndian) { Array($0) }
   }
}
