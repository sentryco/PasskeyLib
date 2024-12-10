import CryptoKit
import Foundation

/** Validates the authenticity of a signature using the provided public key and data.
 * - Description: This function attempts to verify a digital signature by using the public key to ensure that
 * - Note: the signature was generated from the corresponding private key and matches the original data.
 * - Parameters:
 *   - publicKeyData: The raw representation of the public key as `Data`.
 *   - signature: The digital signature as `Data` that needs to be verified.
 *   - data: The original data that was signed, provided as `Data`.
 * - Returns: A Boolean value indicating whether the signature is valid (`true`) or not (`false`).
 * - Throws: An error if the public key cannot be created from the provided data or if any other
 *           error occurs during the signature verification process.
 */
func validateSignature(publicKeyData: Data, signature: Data, data: Data) throws -> Bool {
    do {
        // Convert the raw public key data into a usable public key
        let publicKey = try Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData)
        // Verify the signature
        if publicKey.isValidSignature(signature, for: data) {
            print("The signature is valid.")
            return true
        } else {
            print("The signature is invalid.")
            return false
        }
    } catch {
        print("An error occurred while creating the public key or verifying the signature: \(error)")
        throw error
    }
}
