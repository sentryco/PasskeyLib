import Foundation
/**
 * Represents an Authenticator Attestation GUID (AAGUID).
 * - Description: A 16-byte identifier that indicates the type of the authenticator. The AAGUID is used 
 *   during attestation to identify the model of the authenticator. For privacy-preserving authenticators,
 *   this may be all zeros.
 */
public typealias AAGUID = [UInt8]
/**
 * Constants for commonly used AAGUID values
 */
extension AAGUID {
   /**
    * The default AAGUID value consisting of all zeros.
    * - Description: This represents a privacy-preserving authenticator that does not reveal its specific
    *   model information. Many authenticators use this value to enhance user privacy.
    * - Returns: An array of 16 zero bytes representing the default AAGUID.
    */
   public static var defaultAAGUID: AAGUID {
      return [
         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
         0x00,
      ]
   }
}
