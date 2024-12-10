import Foundation
import CryptoKit
import Foundation

struct AuthenticatorData {
    let rpIdHash: Data
    let flags: UInt8
    let signCount: UInt32
    let attestedCredentialData: AttestedCredentialData?

    init(data: Data) {
        var offset = 0

        // rpIdHash (32 bytes)
        self.rpIdHash = data[offset..<(offset + 32)]
        offset += 32

        // Flags (1 byte)
        self.flags = data[offset]
        offset += 1

        // Sign count (4 bytes, big-endian)
        let signCountData = data[offset..<(offset + 4)]
        self.signCount = UInt32(bigEndian: signCountData.withUnsafeBytes { $0.load(as: UInt32.self) })
        offset += 4

        // Attested Credential Data (if present)
        if (flags & 0x40) != 0 { // Check if AT flag is set
            self.attestedCredentialData = AttestedCredentialData(data: data, offset: &offset)
        } else {
            self.attestedCredentialData = nil
        }
    }
}
// Helper
extension AuthenticatorData {
    /**
    * Generates authenticator data for a given relying party.
    * _ Description: This function constructs a byte sequence that represents authenticator data used in cryptographic operations. It includes the SHA-256 hash of the relying party identifier, user presence and verification flags, and a signature counter.
    * - Parameter relyingParty: A string identifier for the relying party, typically a domain name.
    * - Returns: A `Data` object representing the authenticator data.
    */
    internal func authenticatorData(relyingParty: String) -> Data {
        // Convert the relying party identifier to Data using UTF-8 encoding.
        let rpIDData = Data(relyingParty.utf8)
        // Compute SHA-256 hash of the relying party identifier.
        let rpIDHash = Data(SHA256.hash(data: rpIDData))
        // Define flags indicating user presence, verification, and other attributes.
        let flags = AuthDataFlags.uv | AuthDataFlags.up | AuthDataFlags.be | AuthDataFlags.bs
        // Initialize a counter to zero, represented as 4 bytes of zero data.
        let counter = Data(repeating: 0, count: 4)
        // Combine all components to form the authenticator data.
        var result = Data()
        result.append(rpIDHash)
        result.append(flags)
        result.append(counter)
        assert(result.count == 37) // Ensure the data structure is correctly formed.
        return result
    }
}
