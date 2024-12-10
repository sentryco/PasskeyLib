import AuthenticationServices
import CryptoKit
import Foundation

/// Represents the data associated with a passkey credential.
///
/// This structure encapsulates all necessary details required to manage a passkey credential,
/// including identifiers, user information, and cryptographic keys.
///
/// - Note: Consider renaming to `AuthenticationCredential` for clarity.
/// - Fix: Consider adding `displayName` to provide a human-readable name for the passkey.
struct PKData: Codable {
    /// A unique identifier for the passkey, encoded in base64.
    /// This is typically used to reference the passkey in a database or similar storage system.
    let credentialID: String
    
    /// The domain of the relying party (website or service) that the passkey is associated with.
    /// Example: "example.com"
    let relyingParty: String
    
    /// The username associated with the passkey.
    /// This is typically the user's email or a unique username. "user123"
    let username: String
    
    /// A unique user handle, encoded in base64.
    /// This handle is used to uniquely identify the user independently of other user attributes.  "WVhOa1lYTmtNakl5",
    let userHandle: String
    
    /// The public key associated with the passkey, stored as a base64 encoded string.
    /// This key is used during the authentication process to verify the user's identity. "MIIBIjANBgkqhkiG9w0BAQE...""
    let publicKey: String
    
    /// The private key associated with the passkey, stored securely.
    /// This key should be stored in a manner that prevents unauthorized access, as it is used to
    /// authenticate the user by proving ownership of the corresponding public key.
    let privateKey: String
}
 