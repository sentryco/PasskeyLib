import Foundation
import SwiftCBOR
/**
 * ref: https://github.com/dqj1998/dFido2Lib-ios/blob/2ed7d0ffb9f74fadf1b88b69c17af758b3798329/dFido2LibCore/Authenticator.swift#L95
 */
struct AttestedCredentialData {
   let aaguid: Data
   let credentialId: Data
   let credentialPublicKey: Data?
   
   init?(data: Data, offset: inout Int) {
      /**
       * Ensure there are enough bytes for AAGUID (16 bytes)
       */
      guard offset + 16 <= data.count else { return nil }
      /**
       * Extract AAGUID
       */
      self.aaguid = data.subdata(in: offset..<(offset + 16))
      offset += 16
      
      /**
       * Ensure there are enough bytes for Credential ID Length (2 bytes)
       */
      guard offset + 2 <= data.count else { return nil }
      /**
       * Extract Credential ID Length
       */
      let credentialIdLengthData = data.subdata(in: offset..<(offset + 2))
      let credentialIdLength = UInt16(bigEndian: credentialIdLengthData.withUnsafeBytes { $0.load(as: UInt16.self) })
      offset += 2
      
      /**
       * Ensure there are enough bytes for Credential ID
       */
      guard offset + Int(credentialIdLength) <= data.count else { return nil }
      /**
       * Extract Credential ID
       */
      self.credentialId = data.subdata(in: offset..<(offset + Int(credentialIdLength)))
      offset += Int(credentialIdLength)
      
      /**
       * Extract Credential Public Key (CBOR encoded), if present
       */
      if offset < data.count {
         let remainingData: Data = data.subdata(in: offset..<data.count)
         let decoder = CBORDecoder(input: remainingData.bytes)
         do {
            _ = try decoder.decodeItem()
            /**
             * - Fixme: ⚠️️ try to get the consumedBytes somehow
             */
            let consumedBytes = 0 // decoder.pos
            self.credentialPublicKey = remainingData.subdata(in: 0..<consumedBytes)
            offset += consumedBytes
         } catch {
            self.credentialPublicKey = nil
         }
      } else {
         self.credentialPublicKey = nil
      }
   }
}
