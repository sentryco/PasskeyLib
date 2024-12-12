import AuthenticationServices
import CryptoKit
import Foundation

extension PKData {
    /**
     * Creates an instance of `ASPasskeyCredentialIdentity` using provided parameters.
     * - Description: This method is typically used to convert raw passkey data along with a user identifier into a structured passkey credential identity.
     * - Parameters:
     *   - recordIdentifier: An optional unique identifier for the credential record, used to reference the credential in a database or storage system.
     * - Returns: An `ASPasskeyCredentialIdentity` instance populated with the provided data.
     * - Fixme: ⚠️️ this is missing some code, figure it out
     */
    public func getASPasskeyCredentialIdentity(recordIdentifier: String?) -> ASPasskeyCredentialIdentity? {
       guard let userHandleData = self.userHandleData else { print("err"); return nil }
       guard let credentialIDData = self.credentialIDData else { print("err"); return nil }
        return .init(
            relyingPartyIdentifier: relyingParty, // The identifier for the relying party (e.g., a server) that the credential is associated with.
            userName: username, // The username associated with the credential.
            credentialID: credentialIDData, // Unique identifier for the credential.
            userHandle: userHandleData, // Data representing the user handle.
            recordIdentifier: recordIdentifier // Optional unique identifier for the credential record.
        )
    }
}
