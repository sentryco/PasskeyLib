import AuthenticationServices
import SwiftCBOR

struct AttestationObject {
   /**
    * The format of the attestation statement, typically a string like "none", "packed", "tpm", etc.
    */
   let format: String
   /**
    * The attestation statement, which is a CBOR map containing various cryptographic proofs and metadata.
    */
   let attestationStatement: [CBOR: CBOR]
   /**
    * The authenticator data, which includes information about the authenticator and the credential.
    */
   let authData: AuthenticatorData
   /**
    * - Description: Initializes an `AttestationObject` from a CBOR data structure.
    * - Returns: An optional `AttestationObject` if the CBOR data structure is valid, otherwise `nil`.
    * - Parameter cborData: The CBOR data structure to decode.
    * fixme: make this throw
    */
   init?(from cborData: CBOR?) {
       guard let cborData = cborData else {
           return nil
       }
       guard case let CBOR.map(cborMap) = cborData else {
           return nil
       }

       // Extract "fmt" field
       guard let fmtCBOR = cborMap[CBOR(stringLiteral: "fmt")],
             case let CBOR.utf8String(fmt) = fmtCBOR else {
           return nil
       }

       // Extract "attStmt" field
       guard let attStmtCBOR = cborMap[CBOR(stringLiteral: "attStmt")],
             case let CBOR.map(attStmt) = attStmtCBOR else {
           return nil
       }

       // Extract "authData" field
       guard let authDataCBOR = cborMap[CBOR(stringLiteral: "authData")],
             case let CBOR.byteString(authDataBytes) = authDataCBOR else {
           return nil
       }

       // Assign the extracted format string to the format property
       self.format = fmt
       // Assign the extracted attestation statement map to the attestationStatement property
       self.attestationStatement = attStmt

       // Initialize the authData property with the extracted authenticator data bytes
       do {
           self.authData = try AuthenticatorData(data: Data(authDataBytes))
       } catch {
           Swift.print("error: \(error)")
           return nil
       }
   }
}
/**
 * Function to decode the attestation object
 * - Parameter attestationData: The data representing the attestation object to decode.
 * - Returns: An optional `AttestationObject` if decoding is successful, otherwise `nil`.
 */
internal func decodeAttestationObject(_ attestationData: Data) -> AttestationObject? {
   // Convert Data to [UInt8]
   let attestationBytes = attestationData.bytes
   // Decode the attestation object using SwiftCBOR
   let decoded = try? CBOR.decode(attestationBytes)
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
   let authenticatorData: AuthenticatorData = attestationObject.authData
   // The public key is typically found in the attestedCredentialData part of the authenticatorData
   if let publicKey = authenticatorData.attestedData?.publicKey {
      return Data.init(publicKey)
   } else {
      return .init()
   }
}
