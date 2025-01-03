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
      signUsingES256(challenge, privateKeyStr: privateKeyStr) ??
      signUsingEd25519(challenge, privateKeyStr: privateKeyStr)
   }
}
/**
 * Private
 */
extension PKSigner {
   /**
    * Signs a given challenge using ES256 algorithm.
    * - Description: This method signs the given challenge using the ES256 algorithm.
    * - Abstract: This method attempts to sign the challenge using the ES256 algorithm, which is based on the P-256 curve and the ECDSA signature scheme.
    * - Parameters:
    *   - challenge: The data to be signed.
    *   - privateKey: The PEM representation of the ES256 private key.
    * - Returns: The DER representation of the signature or `nil` if an error occurs.
    */
   fileprivate static func signUsingES256(_ challenge: Data, privateKeyStr: String) -> Data? {
      let privateKey: P256.Signing.PrivateKey
      do {
         privateKey = try P256.Signing.PrivateKey(pemRepresentation: privateKeyStr)
      } catch {
         let message = (error as NSError).debugDescription
         print("Failed to parse as ES256 private key: \(message)")
         return nil
      }
      do {
         let signature = try privateKey.signature(for: challenge)
         return signature.derRepresentation
      } catch {
         let message = (error as NSError).debugDescription
         print("Failed to sign using ES256: \(message)")
         return nil
      }
   }
   /**
    * Signs a given challenge using Ed25519 algorithm.
    * - Description: This method signs the given challenge using the Ed25519 algorithm.
    * - Abstract: This method attempts to sign the challenge using the Ed25519 algorithm, which is based on the EdDSA signature scheme.
    * - Parameters:
    *   - challenge: The data to be signed.
    *   - privateKey: The PEM representation of the Ed25519 private key.
    * - Returns: The signature as `Data` or `nil` if an error occurs.
    */
   fileprivate static func signUsingEd25519(_ challenge: Data, privateKeyStr: String) -> Data? {
      let privateKey: Curve25519.Signing.PrivateKey
      do {
         privateKey = try Curve25519.Signing.PrivateKey(pemRepresentation: privateKeyStr)
      } catch {
         let message = (error as NSError).debugDescription
         print("Failed to parse as EdDSA private key: \(message)")
         return nil
      }
      do {
         let signature = try privateKey.signature(for: challenge)
         return signature
      } catch {
         let message = (error as NSError).debugDescription
         print("Failed to sign using EdDSA: \(message)")
         return nil
      }
   }
}
