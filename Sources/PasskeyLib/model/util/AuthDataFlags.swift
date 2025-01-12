import Foundation
/**
 * Represents the flags used in authenticator data during WebAuthn operations.
 * - Description: This enumeration defines the bit flags that can be present in the authenticator data structure,
 *   indicating various states and capabilities of the authenticator during the operation.
 */
enum AuthDataFlags {
   /**
    * User Present (UP) flag.
    * - Description: Indicates that the user was present during the operation, typically through a simple test of user presence.
    */
   static let up: UInt8   = 0x01
   /**
    * Reserved for Future Use (RFU1).
    * - Description: This bit is reserved for future use and should be set to zero.
    */
   static let rfu1: UInt8 = 0x02
   /**
    * User Verified (UV) flag.
    * - Description: Indicates that the user was verified by the authenticator using a biometric or PIN.
    */
   static let uv: UInt8   = 0x04
   /**
    * Backup Eligibility (BE) flag.
    * - Description: Indicates if the credential is eligible for backup/sync operations.
    */
   static let be: UInt8   = 0x08
   /**
    * Backup State (BS) flag.
    * - Description: Indicates if the credential is currently backed up.
    */
   static let bs: UInt8   = 0x10
   /**
    * Reserved for Future Use (RFU2).
    * - Description: This bit is reserved for future use and should be set to zero.
    */
   static let rfu2: UInt8 = 0x20
   /**
    * Attested Credential Data (AT) flag.
    * - Description: Indicates that attested credential data is included in the authenticator data.
    */
   static let at: UInt8   = 0x40
   /**
    * Extension Data (ED) flag.
    * - Description: Indicates that extension data is included in the authenticator data.
    */
   static let ed: UInt8   = 0x80

   
}
