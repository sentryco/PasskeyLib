import AuthenticationServices
import CryptoKit
import Foundation

extension PKData {
    // init new
    init(relyingParty: String, username: String, userHandle: Data) {
         let aaguid = UUID(uuidString: "EFAA1234-ABCD-5678-90EF-1234567890AB")!

          let privateKey: P256.Signing.PrivateKey
          let credentialIDSizeInBytes = 32
          let publicKeySizeInBytes = 64
          self.privateKey = P256.Signing.PrivateKey()
        let credentialID = (try? CryptoManager.getRandomBytes(count: credentialIDSizeInBytes).asData) ?? Data()

        self.init(
            credentialID: credentialID,
            privateKeyPEM: privateKey.pemRepresentation,
            relyingParty: relyingParty,
            username: username,
            userHandle: userHandle
        )
    }
    // init with params
    func init(with params: PKRegistration) throws -> NewPasskey {
        guard params.supportedAlgorithms.contains(.ES256) else {
            Diag.error("Supported algorithms do not include ES256, cancelling")
            throw PasskeyRegistrationError.unsupportedAlgorithm
        }
        return NewPasskey(
            relyingParty: params.identity.relyingPartyIdentifier,
            username: params.identity.userName,
            userHandle: params.identity.userHandle)
    }
}

extension PKData {
    
    public static 

    public func makeRegistrationCredential(clientDataHash: Data) -> ASPasskeyRegistrationCredential {
        let attestationObject = AttestationObject.attestationObject()
        let credential = ASPasskeyRegistrationCredential(
            relyingParty: relyingParty,
            clientDataHash: clientDataHash,
            credentialID: credentialID,
            attestationObject: attestationObject)
        return credential
    }

}
 
