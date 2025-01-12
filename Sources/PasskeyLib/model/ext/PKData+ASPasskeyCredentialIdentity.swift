import AuthenticationServices
import CryptoKit
import Foundation
/**
 * ASPasskeyCredentialIdentity
 */
extension PKData {
        // Start of Selection
        /**
         * Creates an instance of `ASPasskeyCredentialIdentity` using the stored passkey data.
         *
         * - Parameters:
         *   - recordIdentifier: An optional unique identifier for the credential record, used to reference the credential in a database or storage system.
         * - Returns: An optional `ASPasskeyCredentialIdentity` instance populated with the passkey data.
         * - Note: This method is available on iOS 15.0+, macOS 15.0+, and will return nil on earlier OS versions.
         */
        public func getASPasskeyCredentialIdentity(recordIdentifier: String?) -> ASPasskeyCredentialIdentity? {
            guard #available(iOS 15.0, macOS 15.0, *) else {
                print("Error: ASPasskeyCredentialIdentity is not available on this OS version.")
                return nil
            }
            guard let userHandleData = self.userHandleData,
                  let credentialIDData = self.credentialIDData else {
                print("Error: Missing userHandleData or credentialIDData.")
                return nil
            }
            return ASPasskeyCredentialIdentity(
                relyingPartyIdentifier: relyingParty, // The identifier for the relying party (e.g., a server) that the credential is associated with.
                userName: username,                   // The username associated with the credential.
                credentialID: credentialIDData,       // Unique identifier for the credential.
                userHandle: userHandleData,           // Data representing the user handle.
                recordIdentifier: recordIdentifier    // Optional unique identifier for the credential record.
            )
        }
}
