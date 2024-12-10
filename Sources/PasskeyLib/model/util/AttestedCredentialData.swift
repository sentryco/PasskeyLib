import Foundation
import SwiftCBOR

struct AttestedCredentialData {
    let aaguid: Data
    let credentialId: Data
    let credentialPublicKey: Data?

    init?(data: Data, offset: inout Int) {
        guard offset + 16 <= data.count else { return nil }
        // AAGUID (16 bytes)
        self.aaguid = data[offset..<(offset + 16)]
        offset += 16

        // Credential ID Length (2 bytes)
        guard offset + 2 <= data.count else { return nil }
        let credentialIdLengthData = data[offset..<(offset + 2)]
        let credentialIdLength = UInt16(bigEndian: credentialIdLengthData.withUnsafeBytes { $0.load(as: UInt16.self) })
        offset += 2

        // Credential ID (variable length)
        guard offset + Int(credentialIdLength) <= data.count else { return nil }
        self.credentialId = data[offset..<(offset + Int(credentialIdLength))]
        offset += Int(credentialIdLength)

        // Credential Public Key (CBOR encoded)
        if offset < data.count {
            let remainingData = data[offset...]
            if let (publicKeyCbor, consumedBytes) = try? CBOR.decodeWithIntLength(remainingData) {
                self.credentialPublicKey = Data(remainingData[..<consumedBytes])
                offset += consumedBytes
            } else {
                self.credentialPublicKey = nil
            }
        } else {
            self.credentialPublicKey = nil
        }
    }
}