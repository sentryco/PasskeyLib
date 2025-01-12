import CryptoKit
import Foundation

public class PKValidator {}

extension PKValidator {
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
   public static func validateSignature(publicKeyData: Data, signature: Data, data: Data) throws -> Bool {
       // Convert the raw public key data into a usable public key
       let publicKey = try Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData)
       // Verify the signature
       return publicKey.isValidSignature(signature, for: data)
   }
}
/**
 * Ext
 */
extension P256.Signing.PublicKey {
   /**
    * Verifies a signature for given data using this public key.
    * - Parameters:
    *   - signature: The signature to verify.
    *   - data: The data that was supposedly signed.
    * - Returns: A Boolean value indicating whether the signature is valid.
    * - Fixme: ⚠️️ This is not in use yet, figure out if we need it, and make it throw
    */
   public func isValidSignature(_ signature: Data, for data: Data) -> Bool {
      // Convert the signature from Data to a CryptoKit signature type
      guard let cryptoSignature = try? P256.Signing.ECDSASignature(derRepresentation: signature) else {
         print("Failed to verify signature")
         return false
      }
      // Use CryptoKit's built-in verification method
      return self.isValidSignature(cryptoSignature, for: data)
   }
}
// do {
//    // Convert the raw public key data into a usable public key
//    let publicKey = try Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData)
//    // Verify the signature
//    if publicKey.isValidSignature(signature, for: data) {
//       print("The signature is valid.")
//       return true
//    } else {
//       print("The signature is invalid.")
//       return false
//    }
// } catch {
//    print("An error occurred while creating the public key or verifying the signature: \(error)")
//    throw error
// }
