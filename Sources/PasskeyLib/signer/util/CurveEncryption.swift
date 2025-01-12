import CryptoKit
import Foundation
/**
 * Constants used for PEM encoding boundaries and raw key size.
 */
private let pemHeader = "-----BEGIN PRIVATE KEY-----"
/**
 * The footer string used in PEM encoding to denote the end of a private key.
 */
private let pemFooter = "-----END PRIVATE KEY-----"
/**
 * The size of the raw private key in bytes.
 * - Note: This constant defines the expected length of a raw private key for Curve25519.
 */
private let rawPrivateKeySize = 32
    /**
     * ASN.1 prefix for Curve25519 private key to ensure the data is correctly formatted.
     * - Description: This prefix is used to validate and correctly format the ASN.1 data for a Curve25519 private key.
     * - Note: The prefix ensures that the private key data adheres to the expected structure for Curve25519 keys.
     */
    private let privateKeyASN1Prefix = Data([
        0x30, 0x2E,                // SEQUENCE (length 46)
        0x02, 0x01, 0x00,          // INTEGER (version 0)
        0x30, 0x05,                // SEQUENCE (length 5)
        0x06, 0x03,                // OBJECT IDENTIFIER (length 3)
        0x2B, 0x65, 0x70,          // OID 1.3.101.112 (id-Ed25519)
        0x04, 0x22,                // OCTET STRING (length 34)
        0x04, 0x20                 // OCTET STRING (length 32) - the private key bytes follow
    ])
    // swiftlint:enable collection_alignment

extension Curve25519.Signing.PrivateKey {
    /**
     * Initializes a Curve25519 Signing PrivateKey from a PEM string representation.
     * - Description: This initializer decodes a PEM encoded string to extract the raw private key data, validates it against expected ASN.1 prefix, and then initializes the PrivateKey.
     * - Abstract: This initializer decodes a PEM encoded string to extract the raw private key data, validates it against the expected ASN.1 prefix, and then initializes the PrivateKey.
     * - Parameter pem: The PEM encoded string of the private key.
     * - Throws: `CryptoKitError.invalidParameter` if the PEM format is incorrect or the base64 data is invalid.
     *           `CryptoKitError.incorrectKeySize` if the decoded key size is not as expected.
     */
    internal init(pemRepresentation pem: String) throws {
        // Trim whitespace and newlines from the PEM string.
        let trimmedPem = pem.trimmingCharacters(in: .whitespacesAndNewlines)
        // Ensure the PEM string has the correct header and footer.
        guard trimmedPem.hasPrefix(pemHeader), trimmedPem.hasSuffix(pemFooter) else {
            print("Missing PEM header/footer")
            throw CryptoKitError.invalidParameter
        }
        // Extract the base64 encoded string between the PEM headers.
        let base64String = trimmedPem
            .replacingOccurrences(of: pemHeader, with: "")
            .replacingOccurrences(of: pemFooter, with: "")
            .components(separatedBy: .whitespacesAndNewlines)
            .joined()
        // Decode the base64 string into ASN.1 data.
        guard let asn1Data = Data(base64URLEncoded: base64String) else {
            print("Failed to parse Base64 data")
            throw CryptoKitError.invalidParameter
        }
        // Verify the ASN.1 data starts with the expected prefix.
        guard asn1Data.starts(with: privateKeyASN1Prefix) else {
            print("ASN1 does not match the expected prefix")
            throw CryptoKitError.invalidParameter
        }
        // Extract the raw key data by removing the prefix.
        let rawKeyRepresentation = asn1Data.dropFirst(privateKeyASN1Prefix.count)
        // Ensure the raw key data is of the expected size.
        guard rawKeyRepresentation.count == rawPrivateKeySize else {
            print("Unexpected raw key size: \(rawKeyRepresentation.count)")
            throw CryptoKitError.incorrectKeySize
        }
        // Initialize the private key with the raw key data.
        try self.init(rawRepresentation: rawKeyRepresentation)
    }
}
