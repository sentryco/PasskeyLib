import AuthenticationServices
import CryptoKit
import Foundation
/**
 * Represents the registration data required for a passkey in the context of WebAuthn.
 * - Description: This type alias defines a tuple used to encapsulate various elements needed during the registration of a passkey credential. It is particularly used with Web Authentication (WebAuthn) processes, which is a web standard for secure and passwordless authentication.
 * - Parameters:
 *   - identity: An instance of `ASPasskeyCredentialIdentity`. This identity is used to uniquely
 *               identify the passkey credential. It typically includes information such as the
 *               relying party (RP) identifier and the user handle. For passkey registrations,
 *               the `credentialID` is expected to be empty.
 *   - userVerificationPreference: Specifies the user verification preference for the registration
 *                                 process. This preference indicates whether and how the user
 *                                 verification should be conducted (e.g., preferred, required, or
 *                                 discouraged).
 *   - clientDataHash: A hash of the client data, represented as a `Data` object. The client data
 *                     typically includes contextual information about the WebAuthn operation, such
 *                     as the origin of the operation and the challenge from the server.
 *   - supportedAlgorithms: An array of `ASCOSEAlgorithmIdentifier` that specifies the cryptographic
 *                          algorithms supported by the client for the registration process. This
 *                          allows the server to choose a compatible algorithm for key generation
 *                          during the credential creation.
 * - Note: Empty credential ID is expected for passkey registrations (identity.credentialID.isEmpty)
 * - Fixme: ⚠️️ use struct here?
 */
public struct PKRegistration {
   let identity: ASPasskeyCredentialIdentity
   let userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference
   let clientDataHash: Data
   let supportedAlgorithms: [ASCOSEAlgorithmIdentifier]
}
