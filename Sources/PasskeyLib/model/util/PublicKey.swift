import Foundation
/**
 * Represents a public key used in cryptographic operations.
 * - Description: This protocol defines the necessary properties and methods for a public key, including the algorithm identifier and a method to convert the key to its CBOR byte array representation.
 */
public protocol PublicKey {
   /**
    * The algorithm identifier for the public key.
    * - Description: This property specifies the COSE algorithm identifier associated with the public key.
    */
   var algorithm: COSEAlgorithmIdentifier { get }
   /**
    * Converts the public key to its CBOR byte array representation.
    * - Returns: A byte array representing the public key in CBOR format.
    */
   func cborByteArrayRepresentation() -> [UInt8]
}
