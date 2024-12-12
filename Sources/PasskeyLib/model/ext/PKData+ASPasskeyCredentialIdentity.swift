import AuthenticationServices
import CryptoKit
import Foundation

extension PKData {
    /**
     * Creates an instance of `ASPasskeyCredentialIdentity` using provided parameters.
     * - Description: This method is typically used to convert raw passkey data along with a user identifier into a structured passkey credential identity.
     * - Parameters:
     *   - recordIdentifier: An optional unique identifier for the credential record, used to reference the credential in a database or storage system.
     *   - username: The username associated with the credential. This is typically used for display purposes or during authentication processes.
     *   - credentialID: A blob of data that uniquely identifies the credential. This is used by the authentication system to locate the credential.
     *   - userHandle: A blob of data that represents the user handle. This is used to associate the credential with a specific user entity.
     * - Returns: An `ASPasskeyCredentialIdentity` instance populated with the provided data.
     * - Fixme: ⚠️️ this is missing some code, figure it out
     */
    public func getASPasskeyCredentialIdentity(recordIdentifier: String?) -> ASPasskeyCredentialIdentity? {
       guard let userHandleData = self.userHandleData else { print("err"); return nil }
       guard let credentialIDData = self.credentialIDData else { print("err"); return nil }
        return .init(
            // - Fixme: ⚠️️ get relyingParty from somewhere?
            relyingPartyIdentifier: "", // The identifier for the relying party (e.g., a server) that the credential is associated with.
            userName: self.username, // The username associated with the credential.
            credentialID: credentialIDData, // Unique identifier for the credential.
            userHandle: userHandleData, // Data representing the user handle.
            recordIdentifier: recordIdentifier // Optional unique identifier for the credential record.
        )
    }
}
