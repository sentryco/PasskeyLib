import AuthenticationServices
import CryptoKit
import Foundation

/** Represents the data associated with a passkey credential.
 * - Abstract: PKData is used to store a passkey on user device. PKData allows you to authenticate passkey challanges from external services.
 * - Description: This structure encapsulates all necessary details required to manage a passkey credential, including identifiers, user information, and cryptographic keys.
 * - Note: Consider renaming to `AuthenticationCredential` for clarity.
 * - Remark: Properties in PKData are binary data, we use Base64-encode on these individual properties before JSON serialization.
 * - Fixme: ⚠️️ Consider adding `displayName` to provide a human-readable name for the passkey.
 */
public struct PKData: Codable, Equatable {
    /**
     * A unique identifier for the passkey, encoded in base64.
     * - Description: This is typically used to reference the passkey in a database or similar storage system.
     */
    public let credentialID: String
    /**
     * The domain of the relying party (website or service) that the passkey is associated with.
     * - Note: Example: "example.com"
     */
    public let relyingParty: String
    /**
     * The username associated with the passkey.
     * - Description: This is typically the user's email or a unique username. "user123"
     * - Fixme: ⚠️️ consider removing this? as its not essential?
     */
    public let username: String
    /**
     * A unique user handle, encoded in base64.
     * - Description: This handle is used to uniquely identify the user independently of other user attributes.  "WVhOa1lYTmtNakl5",
     * - Fixme: ⚠️️ consider removing this? as its not essential?
     */
    public let userHandle: String
    /**
     * The private key associated with the passkey, stored securely.
     * - Description: This key should be stored in a manner that prevents unauthorized access, as it is used to authenticate the user by proving ownership of the corresponding public key.
     */
    public let privateKey: String
}
/**
 * The public key associated with the passkey, stored as a base64 encoded string.
 * - Description: This key is used during the authentication process to verify the user's identity. "MIIBIjANBgkqhkiG9w0BAQE...""
 */
//    public let publicKey: String
