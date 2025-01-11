import CryptoKit
import Foundation

public class PKSigner {}

extension PKSigner {
   /**
    * Signs a given challenge using a private key.
    * - Description: This method attempts to sign the challenge using ES256 and if it fails, tries Ed25519.
    * - Abstract: This method attempts to sign the challenge using the ES256 algorithm. If it fails, it tries to sign using the Ed25519 algorithm.
    * - Parameters:
    *   - challenge: The data to be signed.
    *   - privateKey: The PEM representation of the private key.
    * - Returns: The signature as `Data` or `nil` if signing fails.
    */
   public static func signWithPrivateKey(_ challenge: Data, privateKeyStr: String) -> Data? {
      // Attempt to sign the challenge using ES256 with the provided private key
      signUsingES256(challenge, privateKeyStr: privateKeyStr) ??
      // If ES256 signing fails (returns nil), attempt to sign using Ed25519
      signUsingEd25519(challenge, privateKeyStr: privateKeyStr)
   }
}
/**
 * Private
 */
extension PKSigner {
   /**
    * Signs a given challenge using the ES256 algorithm.
    * - Abstract: Function to sign a challenge using the ES256 algorithm
    * - Description: This method signs the given challenge using the ES256 algorithm, which is based on the P-256 curve and the ECDSA signature scheme.
    * - Parameters:
    *   - challenge: The data to be signed.
    *   - privateKeyStr: The PEM representation of the ES256 private key.
    * - Returns: The DER representation of the signature as `Data`, or `nil` if an error occurs.
    */
   fileprivate static func signUsingES256(_ challenge: Data, privateKeyStr: String) -> Data? {
      // Declare a variable to hold the P256 signing private key
      let privateKey: P256.Signing.PrivateKey
      do {
         // Attempt to initialize the private key from its PEM representation
         privateKey = try P256.Signing.PrivateKey(pemRepresentation: privateKeyStr)
      } catch {
         // If initialization fails, get the detailed error message
         let message = (error as NSError).debugDescription
         // Print an error message indicating the failure to parse the ES256 private key
         print("Failed to parse as ES256 private key: \(message)")
         // Return nil to indicate that signing cannot proceed
         return nil
      }
      do {
         // Attempt to sign the challenge data using the private key
         let signature = try privateKey.signature(for: challenge)
         // Return the DER (Distinguished Encoding Rules) representation of the signature
         return signature.derRepresentation
      } catch {
         // If signing fails, get the detailed error message
         let message = (error as NSError).debugDescription
         // Print an error message indicating the failure to sign using ES256
         print("Failed to sign using ES256: \(message)")
         // Return nil to indicate that signing was unsuccessful
         return nil
      }
   }
   /**
    * Signs a given challenge using Ed25519 algorithm.
    * - Description: This method signs the given challenge using the Ed25519 algorithm.
    * - Abstract: This method attempts to sign the challenge using the Ed25519 algorithm, which is based on the EdDSA signature scheme.
    * - Parameters:
    *   - challenge: The data to be signed.
    *   - privateKeyStr: The PEM representation of the Ed25519 private key.
    * - Returns: The signature as `Data` or `nil` if an error occurs.
    */
   fileprivate static func signUsingEd25519(_ challenge: Data, privateKeyStr: String) -> Data? {
      // Define a fileprivate static function to sign data using Ed25519 algorithm
      let privateKey: Curve25519.Signing.PrivateKey
      // Declare a variable to hold the Ed25519 private key
      do {
         // Attempt to initialize the private key from its PEM representation
         privateKey = try Curve25519.Signing.PrivateKey(pemRepresentation: privateKeyStr)
      } catch {
         // Handle any errors that occur during private key initialization
         let message = (error as NSError).debugDescription
         // Obtain a detailed error message
         print("Failed to parse as Ed25519 private key: \(message)")
         // Print an error message indicating the failure to parse the private key
         return nil
         // Return nil to indicate signing cannot proceed without a valid private key
      }
      do {
         // Attempt to sign the challenge data using the private key
         let signature = try privateKey.signature(for: challenge)
         // Generate a signature for the provided challenge data
         return signature
         // Return the signature if signing is successful
      } catch {
         // Handle any errors that occur during the signing process
         let message = (error as NSError).debugDescription
         // Obtain a detailed error message
         print("Failed to sign using Ed25519: \(message)")
         // Print an error message indicating the failure to sign the data
         return nil
         // Return nil to indicate the signing operation failed
      }
   }
}
