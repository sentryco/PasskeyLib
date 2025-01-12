import AuthenticationServices
import CryptoKit
import Foundation
/**
 * Represents the registration data required for a passkey in the context of WebAuthn.
 * - Description: This type alias defines a tuple used to encapsulate various elements needed during the registration of a passkey credential. It is particularly used with Web Authentication (WebAuthn) processes, which is a web standard for secure and passwordless authentication.
 * - Note: Empty credential ID is expected for passkey registrations (identity.credentialID.isEmpty)
 */
public struct PKRegistration {

    /**
     * An `ASPasskeyCredentialIdentity` instance that uniquely identifies the passkey credential.
     * It usually contains information like the relying party (RP) identifier and the user handle.
     * For passkey registrations, the `credentialID` is expected to be empty.
     */
    let identity: ASPasskeyCredentialIdentity

    /**
     * The user verification preference for the registration process, indicating whether and how
     * user verification should be conducted (e.g., preferred, required, or discouraged).
     */
    let userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference

    /**
     * A hash of the client data (`Data`). The client data typically contains contextual
     * information about the WebAuthn operation, such as the origin and the server's challenge.
     */
    let clientDataHash: Data

    /**
     * An array of cryptographic algorithms (`[ASCOSEAlgorithmIdentifier]`) supported by the client
     * during registration. This allows the server to choose a compatible algorithm for key generation
     * when creating the credential.
     */
    let supportedAlgorithms: [ASCOSEAlgorithmIdentifier]

}
