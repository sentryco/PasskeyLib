import CryptoKit
import Foundation
import SwiftCBOR

public struct AuthenticatorData: Equatable {
   public let relyingPartyID: String
   public let flags: AuthenticatorFlags
   public let counter: UInt32
   public let attestedData: AttestedCredentialData?
   public let extData: [UInt8]?
}

extension AuthenticatorData {
   /**
    * do {
    let authenticatorData = try AuthenticatorData(data: yourData)
    // Use authenticatorData as needed
    } catch {
    print("Failed to initialize AuthenticatorData: \(error)")
    }
    */
    public init(data: Data) throws {
        var input = [UInt8](data)
        
        // Extract relyingPartyIDHash (32 bytes)
        guard input.count >= 32 else {
            throw AuthenticatorDataError.invalidData("Insufficient data for relyingPartyIDHash")
        }
        let rpIDHashBytes = Array(input[0..<32])
       let _ = rpIDHashBytes
        input.removeFirst(32)
        self.relyingPartyID = "" // Cannot reverse hash; consider storing hash or adjusting model
        
        // Extract flags (1 byte)
        guard input.count >= 1 else {
            throw AuthenticatorDataError.invalidData("Insufficient data for flags")
        }
        let flagsByte = input.removeFirst()
       self.flags = AuthenticatorFlags(rawValue: flagsByte)
        
        // Extract counter (4 bytes)
        guard input.count >= 4 else {
            throw AuthenticatorDataError.invalidData("Insufficient data for counter")
        }
        let counterBytes = input.prefix(4)
        input.removeFirst(4)
        self.counter = UInt32(bigEndian: Data(counterBytes).withUnsafeBytes { $0.load(as: UInt32.self) })
        
        // Parse attestedData if present
        if flags.contains(AuthenticatorFlags.attestedData) {
            // Implement parsing logic for AttestedCredentialData
            self.attestedData = try AttestedCredentialData(from: &input)
        } else {
            self.attestedData = nil
        }
        
        // Parse extData if present
        if flags.contains(AuthenticatorFlags.extData) {
            // Remaining input is extData
            self.extData = input
        } else {
            self.extData = nil
        }
    }
}

extension AttestedCredentialData {
      init(from input: inout [UInt8]) throws {
          // Parse AAGUID (16 bytes)
          guard input.count >= 16 else {
              throw AuthenticatorDataError.invalidData("Insufficient data for AAGUID")
          }
          let aaguidBytes = Array(input[0..<16])
         let aaguid: AAGUID = aaguidBytes
          input.removeFirst(16)
          
          // Parse credentialID length (2 bytes)
          guard input.count >= 2 else {
              throw AuthenticatorDataError.invalidData("Insufficient data for credentialID length")
          }
          let credentialIDLength = UInt16(bigEndian: Data(input[0..<2]).withUnsafeBytes { $0.load(as: UInt16.self) })
          input.removeFirst(2)
          
          // Parse credentialID
          guard input.count >= credentialIDLength else {
              throw AuthenticatorDataError.invalidData("Insufficient data for credentialID")
          }
          let credentialID = Array(input[0..<Int(credentialIDLength)])
          input.removeFirst(Int(credentialIDLength))
          
          // Parse publicKey (CBOR object)
          // Assume publicKey is the remaining input or parse accordingly
          let publicKeyBytes = input // This may need proper CBOR parsing
          input.removeAll()
          
          self.init(
              aaguid: aaguid,
              credentialID: credentialID,
              publicKey: publicKeyBytes
          )
      }
  }

  enum AuthenticatorDataError: Error {
      case invalidData(String)
  }

extension AuthenticatorData {
   init(
      relyingPartyID: String,
      publicKey: Data,
      credentialId: Data,
      applicationIdentifier: AAGUID = .defaultAAGUID,
      counter: UInt32,
      flags: AuthenticatorFlags
   ) {
      let credentialData = AttestedCredentialData(
         aaguid: applicationIdentifier,
         credentialID: [UInt8](credentialId),
         publicKey: [UInt8](publicKey))
      self.relyingPartyID = relyingPartyID
      self.flags = flags
      self.counter = counter
      self.attestedData = credentialData
      self.extData = nil
   }
}

extension AuthenticatorData {
   
   public struct AttestationInformation {
      public let credentialId: Data
      public let applicationIdentifier: AAGUID
      public let publicKey: PublicKey
      
      public init(
         credentialId: Data,
         applicationIdentifier: AAGUID = .defaultAAGUID,
         publicKey: PublicKey
      ) {
         self.credentialId = credentialId
         self.applicationIdentifier = applicationIdentifier
         self.publicKey = publicKey
      }
      
      func makeAttestedCredentialData() -> AttestedCredentialData {
         AttestedCredentialData(
            aaguid: applicationIdentifier,
            credentialID: [UInt8](credentialId),
            publicKey: [UInt8](publicKey.cborByteArrayRepresentation()))
      }
   }
   
   public init(
      relyingPartyID: String,
      attestationInformation: AttestationInformation?,
      counter: UInt32,
      flags: AuthenticatorFlags
   ) {
      if let attestedData = attestationInformation?.makeAttestedCredentialData() {
         self.attestedData = attestedData
      } else {
         self.attestedData = nil
      }
      self.relyingPartyID = relyingPartyID
      self.flags = flags
      self.counter = counter
      
      self.extData = nil
   }
}

extension AuthenticatorData {
   
   public func byteArrayRepresentation() -> [UInt8] {
      var value = [UInt8]()
      
      value += relyingPartyID.relyingPartyHash()
      
      value += [flags.rawValue]
      
      let counterRepresentation: [UInt8] = withUnsafeBytes(of: counter.bigEndian) {
         Array($0)
      }
      value += counterRepresentation
      
      if let attestedData {
         value += attestedData.bytesRepresentation()
      }
      
      if let extData {
         value += extData
      }
      return value
   }
}

extension String {
   func relyingPartyHash() -> [UInt8] {
      let rpIDData = data(using: .utf8)!
      let rpIDHash = SHA256.hash(data: rpIDData)
      return [UInt8](rpIDHash)
   }
}
/**
 * Generates authenticator data for a given relying party.
 * _ Description: This function constructs a byte sequence that represents authenticator data used in cryptographic operations. It includes the SHA-256 hash of the relying party identifier, user presence and verification flags, and a signature counter.
 * - Parameter relyingParty: A string identifier for the relying party, typically a domain name.
 * - Returns: A `Data` object representing the authenticator data.
 */
internal func authenticatorDataObj(relyingParty: String) -> Data {
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
