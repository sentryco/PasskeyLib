import Foundation
/**
 * Represents the flags used by an authenticator during a WebAuthn operation.
 * - Description: This structure defines an option set of flags that indicate various states or capabilities of an authenticator, such as user presence, user verification, backup eligibility, backup state, and the inclusion of attested data or extension data.
 */
public struct AuthenticatorFlags: OptionSet {
    /**
     * The raw value of the authenticator flags.
     * - Description: This property holds the raw value of the flags as a UInt8.
     */
    public let rawValue: UInt8

    /**
     * Initializes a new instance of `AuthenticatorFlags` with the specified raw value.
     * - Parameter rawValue: The raw value to initialize the flags with.
     */
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    /**
     * Indicates that the user is present during the WebAuthn operation.
     * - Description: This flag is set when the user has performed some action to confirm their presence, such as touching a button or sensor on the authenticator.
     */
    public static let userPresent = AuthenticatorFlags(rawValue: 1 << 0) // UP

    /**
     * Indicates that the user has been verified during the WebAuthn operation.
     * - Description: This flag is set when the user has been successfully verified through an additional authentication factor, such as a PIN, passcode, or biometric recognition.
     */
    public static let userVerified = AuthenticatorFlags(rawValue: 1 << 2) // UV

    /**
     * Indicates that the authenticator is backup eligible.
     * - Description: This flag is set when the authenticator is capable of being backed up.
     */
    public static let backupEligibility = AuthenticatorFlags(rawValue: 1 << 3)

    /**
     * Indicates that the authenticator is currently backed up.
     * - Description: This flag is set when the authenticator's credential is currently backed up.
     */
    public static let backupState = AuthenticatorFlags(rawValue: 1 << 4)

    /**
     * Indicates that attested credential data is included in the authenticator response.
     * - Description: This flag is set when the authenticator response includes attested credential data, which provides information about the authenticator and the credential.
     */
    public static let attestedData = AuthenticatorFlags(rawValue: 1 << 6) // AT

    /**
     * Indicates that extension data is included in the authenticator response.
     * - Description: This flag is set when the authenticator response includes additional extension data, which may provide extra information or functionality beyond the core WebAuthn specification.
     */
    public static let extData = AuthenticatorFlags(rawValue: 1 << 7) // ED
}

//public struct AuthenticatorFlags: Equatable {
//
//   private enum Flag: UInt8 {
//      case userPresent = 0b00000001
//      case userVerified = 0b00000100
//      case backupEligibility = 0b00001000
//      case backupState = 0b00010000
//      case attestedCredDataIncluded = 0b01000000
//      case extensionDataIncluded = 0b10000000
//   }
//
//   let userPresent: Bool
//   let userVerified: Bool
//   let isBackupEligible: Bool
//   let isCurrentlyBackedUp: Bool
//   let attestedCredentialData: Bool
//   let extensionDataIncluded: Bool
//
//   public init(
//      userPresent: Bool = false,
//      userVerified: Bool = false,
//      isBackupEligible: Bool = false,
//      isCurrentlyBackedUp: Bool = false,
//      attestedCredentialData: Bool = false,
//      extensionDataIncluded: Bool = false
//   ) {
//      self.userPresent = userPresent
//      self.userVerified = userVerified
//      self.isBackupEligible = isBackupEligible
//      self.isCurrentlyBackedUp = isCurrentlyBackedUp
//      self.attestedCredentialData = attestedCredentialData
//      self.extensionDataIncluded = extensionDataIncluded
//   }
//
//   public init(flag: UInt8) {
//      userPresent = (flag & Flag.userPresent.rawValue) != 0
//      userVerified = (flag & Flag.userVerified.rawValue) != 0
//      isBackupEligible = (flag & Flag.backupEligibility.rawValue) != 0
//      isCurrentlyBackedUp = (flag & Flag.backupState.rawValue) != 0
//      attestedCredentialData = (flag & Flag.attestedCredDataIncluded.rawValue) != 0
//      extensionDataIncluded = (flag & Flag.extensionDataIncluded.rawValue) != 0
//   }
//}
//
//extension AuthenticatorFlags {
//
//   func byteRepresentation() -> UInt8 {
//      var result: UInt8 = 0b00000000
//
//      if userPresent {
//         result |= Flag.userPresent.rawValue
//      }
//      if userVerified {
//         result |= Flag.userVerified.rawValue
//      }
//      if isBackupEligible {
//         result |= Flag.backupEligibility.rawValue
//      }
//      if isCurrentlyBackedUp {
//         result |= Flag.backupState.rawValue
//      }
//      if attestedCredentialData {
//         result |= Flag.attestedCredDataIncluded.rawValue
//      }
//      if extensionDataIncluded {
//         result |= Flag.extensionDataIncluded.rawValue
//      }
//      return result
//   }
//}
