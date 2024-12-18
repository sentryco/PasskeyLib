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
private let privateKeyASN1Prefix = Data(
    // swiftlint:disable collection_alignment
    [0x30, 0x2E,
        0x02, 0x01, 0x00,
        0x30, 0x05,
            0x06, 0x03,
                0x2B, 0x65, 0x70,
        0x04, 0x22,
            0x04, 0x20
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
        /**
         * Trim whitespace and newlines from the PEM string.
         */
        let pem = pem.trimmingCharacters(in: .whitespacesAndNewlines)
        /**
         * Ensure the PEM string has the correct header and footer.
         */
        guard pem.hasPrefix(pemHeader), pem.hasSuffix(pemFooter) else {
            print("Missing PEM header/footer")
            throw CryptoKitError.invalidParameter
        }
        /**
         * Remove the header and footer to isolate the base64 encoded string.
         */
        let noisyBase64String = pem
            .dropFirst(pemHeader.count)
            .dropLast(pemFooter.count)
        /**
         * Decode the base64 string into ASN.1 data.
         */
        guard let asn1Data = Data(base64URLEncoded: String(noisyBase64String)/*, options: .ignoreUnknownCharacters*/) else {
            print("Failed to parse Base64 data")
            throw CryptoKitError.invalidParameter
        }
        /**
         * Verify the ASN.1 data starts with the expected prefix.
         */
        guard asn1Data.starts(with: privateKeyASN1Prefix) else {
            print("ASN1 does not match the expected prefix")
            throw CryptoKitError.invalidParameter
        }
        /**
         * Extract the raw key data by removing the prefix.
         */
        let rawKeyRepresentation = asn1Data.dropFirst(privateKeyASN1Prefix.count)
        /**
         * Ensure the raw key data is of the expected size.
         */
        guard rawKeyRepresentation.count == rawPrivateKeySize else {
            print("Unexpected raw key size: \(rawKeyRepresentation.count)")
            throw CryptoKitError.incorrectKeySize
        }
        /**
         * Initialize the private key with the raw key data.
         */
        try self.init(rawRepresentation: rawKeyRepresentation)
    }
}
