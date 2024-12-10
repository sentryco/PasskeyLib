import SwiftCBOR
import CryptoKit
import AuthenticationServices

extension CBOR {
    /**
     * Encodes a public key into CBOR format
     * - Description: This method takes a `P256.Signing.PublicKey` and encodes it into a CBOR data structure suitable for cryptographic operations
     * - Parameter publicKey: The public key to encode
     * - Returns: A `Data` object containing the CBOR-encoded public key
     * - Throws: An error if the public key size does not match the expected size
     */
    internal static func cborEncodePublicKey(_ publicKey: P256.Signing.PublicKey) -> Data {
        let rawPublicKey = publicKey.rawRepresentation
        // Ensure the public key is of the expected size, otherwise log an error and fail the operation
        guard rawPublicKey.count == publicKeySizeInBytes else {
            print("Unexpected public key size: \(rawPublicKey.count)")
            print("Unexpected public key size")
            assertionFailure("Public key size is incorrect.")
            return Data()
        }
        // Split the public key into 'x' and 'y' components for CBOR encoding
        let x = Array(rawPublicKey.prefix(upTo: 33))
        let y = Array(rawPublicKey.suffix(32))
        // Create a CBOR map to represent the public key with its components and metadata
        let dict: CBOR = [
            1: CBOR(integerLiteral: 2), // Key type identifier
            3: CBOR(integerLiteral: ASCOSEAlgorithmIdentifier.ES256.rawValue), // Algorithm identifier
            -1: CBOR(integerLiteral: ASCOSEEllipticCurveIdentifier.P256.rawValue),
            -2: CBOR.byteString(x),
            -3: CBOR.byteString(y)
        ]
        let encoded = Data(dict.encode())
        return encoded
    }
    /**
     * Encodes attestation data into CBOR format
     * - Description: This method is used to encode authentication data into a CBOR structure for attestation purposes
     * - Parameter authData: The authentication data to encode
     * - Returns: A `Data` object containing the CBOR-encoded attestation data
     */
    private static func cborEncodeAttestation(_ authData: Data) -> Data {
        // Define the structure of the attestation data in CBOR format
        let dict: CBOR = [
            "fmt": "none", // Format of the attestation statement
            "attStmt": CBOR.map([:]), // Attestation statement (empty in this case)
            "authData": CBOR.byteString(authData.bytes) // Authentication data
        ]
        // Encode the CBOR structure into binary data
        let encoded = dict.encode()
        return Data(encoded)
    }
}
