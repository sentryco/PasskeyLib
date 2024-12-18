import CryptoKit
import Foundation
import SwiftCBOR
/**
 * Represents the authenticator data used in WebAuthn operations.
 * - Description: This structure encapsulates the various components of authenticator data, including the relying party ID, flags, counter, attested credential data, and extension data.
 */
public struct AuthenticatorData: Equatable {
   /**
    * The relying party identifier associated with the authenticator data.
    * - Description: This property represents the identifier of the relying party (e.g., website or application) that the authenticator is interacting with during the WebAuthn operation.
    */
   public let relyingPartyID: String
   /**
    * The flags indicating the state and capabilities of the authenticator.
    * - Description: This property holds an instance of `AuthenticatorFlags`, which represents various flags that provide information about the authenticator's state and capabilities, such as user presence, user verification, and the inclusion of attested credential data or extension data.
    */
   public let flags: AuthenticatorFlags
   /**
    * The signature counter value associated with the authenticator.
    * - Description: This property represents the current value of the signature counter maintained by the authenticator. The counter is incremented each time the authenticator performs a cryptographic operation, helping to prevent replay attacks.
    */
   public let counter: UInt32
   /**
    * The attested credential data, if present in the authenticator data.
    * - Description: This property holds an optional instance of `AttestedCredentialData`, which contains information about the credential used in the WebAuthn operation, such as the credential ID and public key. It is present when the `attestedData` flag is set in the `flags` property.
    */
   public let attestedData: AttestedCredentialData?
   /**
    * The extension data, if present in the authenticator data.
    * - Description: This property holds an optional array of bytes representing the extension data included in the authenticator data. Extension data allows for additional functionality or information to be conveyed beyond the core WebAuthn specification.
    */
   public let extData: [UInt8]?
}
/**
 * Ext
 */
extension AuthenticatorData {
   /**
    * Initializes a new instance of `AuthenticatorData` from the given data.
    * - Parameter data: The raw data representing the authenticator data.
    * - Throws: An error of type `AuthenticatorDataError` if the provided data is invalid or insufficient.
    * # Examples:
    * do {
    *    let authenticatorData = try AuthenticatorData(data: yourData)
    *    // Use authenticatorData as needed
    * } catch {
    *    print("Failed to initialize AuthenticatorData: \(error)")
    * }
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
/**
 * Represents the attested credential data included in an authenticator data structure.
 * - Description: This struct encapsulates the attested credential data that is optionally included in an authenticator data structure. It contains the Authenticator Attestation Globally Unique Identifier (AAGUID), the credential ID, and the public key associated with the credential.
 */
extension AttestedCredentialData {
   /**
    * Initializes a new instance of `AttestedCredentialData` by parsing the input bytes.
    * - Parameter input: A mutable array of bytes containing the attested credential data.
    * - Throws: An `AuthenticatorDataError` if the input data is invalid or insufficient.
    * - Description: This initializer parses the input bytes to extract the AAGUID, credential ID, and public key of the attested credential. It modifies the input array by removing the parsed bytes.
    */
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
/**
 * Represents an error that can occur while processing authenticator data.
 * - Description: This enumeration defines the possible errors that can occur during the parsing or handling of authenticator data. It includes a case for invalid data, which contains a descriptive error message.
 */
enum AuthenticatorDataError: Error {
   case invalidData(String)
}
/**
 * Initiation
 */
extension AuthenticatorData {
   /**
    * Initializes a new instance of `AuthenticatorData` with the provided parameters.
    * - Parameters:
    *   - relyingPartyID: The identifier of the relying party.
    *   - publicKey: The public key data.
    *   - credentialId: The credential identifier data.
    *   - applicationIdentifier: The application identifier (AAGUID). Defaults to `.defaultAAGUID`.
    *   - counter: The counter value.
    *   - flags: The authenticator flags.
    * - Description: This initializer creates a new `AuthenticatorData` instance by constructing an `AttestedCredentialData` object from the provided parameters and setting the corresponding properties of `AuthenticatorData`.
    */
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
/**
 * AttestationInformation
 */
extension AuthenticatorData {
   /**
    * Represents the attestation information for an authenticator.
    * - Description: This structure encapsulates the necessary information for attestation, including the credential ID, application identifier (AAGUID), and the public key associated with the credential.
    * - Properties:
    *   - credentialId: The identifier of the credential.
    *   - applicationIdentifier: The application identifier (AAGUID) associated with the credential. Defaults to `.defaultAAGUID`.
    *   - publicKey: The public key associated with the credential.
    */
   public struct AttestationInformation {
      public let credentialId: Data
      public let applicationIdentifier: AAGUID
      public let publicKey: PublicKey
      /**
       * Initializes a new instance of `AttestationInformation` with the provided parameters.
       * - Parameters:
       *   - credentialId: The identifier of the credential.
       *   - applicationIdentifier: The application identifier (AAGUID) associated with the credential. Defaults to `.defaultAAGUID`.
       *   - publicKey: The public key associated with the credential.
       * - Description: This initializer creates a new `AttestationInformation` instance by setting the corresponding properties with the provided values.
       */
      public init(
         credentialId: Data,
         applicationIdentifier: AAGUID = .defaultAAGUID,
         publicKey: PublicKey
      ) {
         self.credentialId = credentialId
         self.applicationIdentifier = applicationIdentifier
         self.publicKey = publicKey
      }
      /**
       * Creates an `AttestedCredentialData` instance from the `AttestationInformation`.
       * - Returns: An `AttestedCredentialData` instance containing the AAGUID, credential ID, and public key from the `AttestationInformation`.
       * - Description: This method converts the `AttestationInformation` into an `AttestedCredentialData` instance by extracting the necessary information such as the AAGUID, credential ID, and the CBOR byte array representation of the public key.
       */
      func makeAttestedCredentialData() -> AttestedCredentialData {
         AttestedCredentialData(
            aaguid: applicationIdentifier,
            credentialID: [UInt8](credentialId),
            publicKey: [UInt8](publicKey.cborByteArrayRepresentation()))
      }
   }
   /**
    * Initializes a new instance of `AuthenticatorData` with the provided parameters.
    * - Parameters:
    *   - relyingPartyID: The identifier of the relying party.
    *   - attestationInformation: Optional attestation information containing the credential ID, AAGUID, and public key.
    *   - counter: The signature counter value.
    *   - flags: The authenticator flags indicating the state and capabilities of the authenticator.
    * - Description: This initializer creates a new `AuthenticatorData` instance by setting the corresponding properties with the provided values. If attestation information is provided, it is converted to an `AttestedCredentialData` instance and stored in the `attestedData` property. The `relyingPartyID`, `flags`, and `counter` are set directly, while `extData` is set to `nil`.
    */
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
/**
 * Getter
 */
extension AuthenticatorData {
   /**
    * Converts the authenticator data to its byte array representation.
    * - Description: This method serializes the authenticator data into a byte array format according to the WebAuthn specification. The resulting byte array includes:
    *   - The SHA-256 hash of the relying party ID
    *   - The flags byte indicating authenticator state
    *   - The 4-byte signature counter
    *   - The attested credential data (if present)
    *   - The extension data (if present)
    * - Returns: A byte array containing the serialized authenticator data.
    */
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
/**
 * String ext
 */
extension String {
   /**
    * Computes the SHA-256 hash of the relying party identifier.
    * - Returns: An array of UInt8 representing the SHA-256 hash of the relying party identifier.
    */
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
