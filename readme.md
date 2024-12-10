### PasskeyLib

### Description:
Simplifies passkey storage and validation

### Features: 
- Passkey data-object for storing passkey data
- Passkey signing / validation / assertion / verification

### Example Usage:

To generate a new passkey, you would typically interact with the `PKSigning` class to create a signature using a private key. Here's how you can use the `PKSigning` class to sign a challenge:

This example demonstrates initializing a challenge and signing it using a private key. The resulting signature is then printed in a base64 encoded string format. 

```swift
import PasskeyLib

let challengeData = Data("your-challenge-string".utf8)
let privateKey = "your-private-key-string"
let signature = PKSigning.signWithPrivateKey(challengeData, privateKey: privateKey)

if let signature = signature {
    print("Signature: \(signature.base64EncodedString())")
} else {
    print("Failed to generate signature.")
}

``` 

Verifying a Passkey After a passkey is generated and used in an authentication attempt, the server needs to verify the signature against the stored public key. This step ensures that the signature was created by the authenticator possessing the corresponding private key. 

This snippet shows how to verify a signature using the `PKSigning` class. It checks if the signature received from the client matches the one generated using the stored public key. 

```swift 
import PasskeyLib

let publicKey = "your-public-key-string"
let signature = Data(base64Encoded: "your-received-signature-string")!
let challengeData = Data("your-challenge-string".utf8)

let isValid = PKSigning.verifySignature(signature, publicKey: publicKey, challenge: challengeData)

if isValid {
    print("Authentication successful.")
} else {
    print("Authentication failed.")
}
``` 

### Instalation:

Make sure to set the following in your extension's Info.plist:
`<key>ProvidesPasskeys</key><true/>`

In the CredentialProvider / AutoFill extension:

`Info.plist > NSExtension > NSExtensionAttributes > ASCredentialProviderExtensionCapabilities > ProvidesPasskeys = YES`  
`Info.plist > NSExtension > NSExtensionAttributes > ASCredentialProviderExtensionCapabilities > ProvidesPasswords = YES`

**Implement passkey support in AutoFill extension:**  
To support passkeys, implement the following method in your CredentialProviderViewController:
swift

```swift
override func prepareInterface(forPasskeyRegistration registrationRequest: ASCredentialRequest) {
    // Handle passkey registration
}
override func prepareInterface(forPasskeyAssertion assertionRequest: ASCredentialRequest) {
    // Handle passkey assertion
}
override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    // Handle the preparation of the credential list for the given service identifiers
}
override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
    // Handle providing a credential without user interaction for the given credential identity
}
override func prepareInterface(forExtensionConfiguration configuration: ASCredentialProviderExtensionConfiguration) {
    // Handle the preparation of the interface for the given extension configuration
}
```

### Resources: 
- Early u2f swift lib: https://github.com/al45tair/u2f-swift
- Interesting ble+u2f experiement by ledger: https://github.com/LedgerHQ/u2f-ble-test-ios/tree/master
- Comprehensive project on passkey autenticator (also has BLE): https://github.com/kryptco/krypton-ios
- Apples passkey api: https://developer.apple.com/documentation/authenticationservices/asauthorizationwebbrowserpublickeycredentialmanager
- Apples passkey autofill api: https://developer.apple.com/documentation/authenticationservices/ascredentialproviderviewcontroller
- Apple on passkeys: https://developer.apple.com/documentation/authenticationservices/public-private-key-authentication
- Very small sample project for passkeys https://github.com/hansemannn/iOS16-Passkeys-Sample/tree/main
- Interesting webhauthn + passkeys. comprehensive + has nice gifs: https://github.com/lyokato/WebAuthnKit-iOS/tree/develop

### Todo: 
- Add the popular packages for passkeys from that issue. Add it to thihs readme
- An interesting aspect with passkey is that we can use a secondary device to authenticate on. challnage response. So we could build in a sort of require secondary device challange feature. Exclusive.

