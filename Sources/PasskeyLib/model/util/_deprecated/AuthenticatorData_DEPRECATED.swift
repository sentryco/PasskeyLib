import Foundation
import CryptoKit
import Foundation
/**
 * Represents the authenticator data according to the WebAuthn specification.
 */
struct AuthenticatorData_DEPRECATED {
    /**
     * The SHA-256 hash of the relying party's identifier (RP ID).
     */
    let rpIdHash: Data
    /**
     * Flags indicating user presence and verification, and other attributes.
     */
    let flags: UInt8
    /**
     * Signature counter incremented by the authenticator after each successful authentication.
     */
    let signCount: UInt32
    /**
     * The attested credential data, present if the attested credential data flag is set.
     */
    let attestedCredentialData: AttestedCredentialData_DEPRECATED?
   /**
    * - Fixme: ⚠️️ add description
    */
    init(data: Data) {
        var offset = 0
        /**
         * rpIdHash (32 bytes)
         */
        self.rpIdHash = data[offset..<(offset + 32)]
        offset += 32
        /**
         * Flags (1 byte)
         */
        self.flags = data[offset]
        offset += 1
        /**
         * Sign count (4 bytes, big-endian)
         */
        let signCountData = data[offset..<(offset + 4)]
        self.signCount = UInt32(bigEndian: signCountData.withUnsafeBytes { $0.load(as: UInt32.self) })
        offset += 4
        /**
         * Attested Credential Data (if present)
         */
        if (flags & 0x40) != 0 { 
            /**
             * Check if AT flag is set
             */
            self.attestedCredentialData = AttestedCredentialData_DEPRECATED(data: data, offset: &offset)
        } else {
            self.attestedCredentialData = nil
        }
    }
}
