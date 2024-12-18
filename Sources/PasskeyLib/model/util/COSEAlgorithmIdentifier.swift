import Foundation
/**
 * Represents the COSE algorithm identifiers used in cryptographic operations.
 * - Description: This enumeration defines the COSE (CBOR Object Signing and Encryption) algorithm identifiers for various elliptic curve signature algorithms.
 * - Note: The raw values of the cases correspond to the COSE algorithm identifier values.
 */
public enum COSEAlgorithmIdentifier: Int, RawRepresentable, Codable, CaseIterable {
   case es256 = -7
   case es384 = -35
   case es512 = -36
}
