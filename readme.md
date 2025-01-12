[![Tests](https://github.com/sentryco/PasskeyLib/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/PasskeyLib/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/180de22b-8712-452f-ab9a-ccdcbf9a558e)](https://codebeat.co/projects/github-com-sentryco-passkeylib-main)

# PasskeyLib

> Simplifies passkey storage and validation

### Features: 
- 🔑 Passkey data-object for storing passkey data
- 🔏 Passkey signing / validation / assertion / verification

### Instalation: 
Swift package manager: 
```swift
.package(url: "https://github.com/sentryco/PasskeyLib", branch: "main")
```

### Example Usage:

To generate a new passkey, you would typically interact with the `PKSigner` class to create a signature using a private key. Here's how you can use the `PKSigner` class to sign a challenge:

This example demonstrates initializing a challenge and signing it using a private key. The resulting signature is then printed in a base64 encoded string format. 

```swift
import PasskeyLib

// Example challenge data that needs to be signed
let challengeString = "your-challenge-string"
guard let challengeData = challengeString.data(using: .utf8) else {
    print("Failed to convert the challenge string to Data.")
    return
}

// Retrieve or generate your private key in PEM format.
// In a real application, you would securely retrieve the stored private key for the user.
// For this example, we'll generate a new private key.
let privateKey = P256.Signing.PrivateKey()
let privateKeyPEM = privateKey.pemRepresentation

// Sign the challenge data using the private key
if let signature = PKSigner.signWithPrivateKey(challengeData, privateKey: privateKeyPEM) {
    // Signature generated successfully
    // The signature can now be sent to the server for verification
    print("Signature: \(signature.base64URLEncodedString())")
} else {
    // Failed to generate the signature
    print("Failed to generate signature.")
}
``` 

Verifying a Passkey After a passkey is generated and used in an authentication attempt, the server needs to verify the signature against the stored public key. This step ensures that the signature was created by the authenticator possessing the corresponding private key. 

This snippet shows how to verify a signature using the `PKValidator` class. It checks if the signature received from the client matches the one generated using the stored public key. 

```swift 
import PasskeyLib

// Replace with your actual base64-encoded public key string
let publicKey = "your-public-key-string"

// Replace with the base64URL-encoded signature you received
guard let signature = Data(base64URLEncoded: "your-received-signature-string") else {
    print("Invalid signature data.")
    return
}

// The challenge data that was originally sent to the client
let challengeData = Data("your-challenge-string".utf8)

// Verify the signature
let isValid = PKValidator.verifySignature(signature, publicKey: publicKey, challenge: challengeData)

if isValid {
    print("Authentication successful.")
} else {
    print("Authentication failed.")
}
``` 

Creating an Assertion Credential (ASPasskeyAssertionCredential)

```swift
import PasskeyLib

// Prepare your client data hash (e.g., SHA256 hash of your client data)
let clientDataJSON = "{\"challenge\":\"your-challenge-value\"}".data(using: .utf8)!
let clientDataHash = SHA256.hash(data: clientDataJSON)

// Initialize your PKData instance with your passkey details
let pkData = PKData(
    credentialID: "your-credential-id-base64url",
    relyingParty: "example.com",
    username: "user@example.com",
    userHandle: "your-user-handle-base64url",
    privateKey: "your-private-key-string"
)

do {
    // Generate the assertion credential
    let assertionCredential = try pkData.getAssertionCredential(clientDataHash: clientDataHash)
    // Use the assertionCredential as needed, e.g., send it to your server
} catch {
    print("Failed to create assertion credential: \(error)")
}
```

### JSON Format:

Below is an example of a `PKData` object represented in JSON format. Note that some fields are base64-encoded to represent binary data.

```json
{
    "credentialID": "Y3JlZGVudGlhbC1pZC1leGFtcGxl",
    "relyingParty": "securebank.com",
    "username": "john.doe",
    "userHandle": "dXNlci1oYW5kbGUtc2FtcGxl",
    "privateKey": "cHJpdmF0ZS1rZXktZXhhbXBsZQ=="
}
```

**Explanation:**

- `credentialID`: Base64-encoded string of `"credential-id-example"`.
- `relyingParty`: The domain of the relying party, e.g., `"securebank.com"`.
- `username`: The username associated with the passkey, e.g., `"john.doe"`.
- `userHandle`: Base64-encoded string of `"user-handle-sample"`.
- `privateKey`: Base64-encoded string of `"private-key-example"`.

**Note:** When parsing this JSON, remember to decode the base64-encoded fields (`credentialID`, `userHandle`, `privateKey`) to obtain the original binary data.


### Config:

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
- Lots of passkey code for swift: https://github.com/tkhq/swift-sdk/blob/35a3f203d406eaaf64cc647f4c001deddb69c365/Sources/Shared/PasskeyManager.swift
- AttestationObj etc: https://github.com/Dashlane/apple-apps/tree/e66b4b162ac898c751b9ca0403dcb792cf70a566/Packages/Foundation/AppleWebAuthn/Sources/WebAuthn
- More AttestationObj: https://github.com/ForgeRock/forgerock-ios-sdk/tree/57567fd627c10cd3432cb53749f851abec755a67/FRAuth/FRAuth/WebAuthn/Authenticator
- Fido2 code for iOS (comprehensive): https://github.com/dqj1998/dFido2Lib-ios

### Todo: 
- An interesting aspect with passkey is that we can use a secondary device to authenticate on. challnage response. So we could build in a sort of require secondary device challange feature. Exclusive.
- Investigate if we can broadcast receipt from another device. If that works, we could build in passkey support for chrome. by scanning the qr in chrome. and then broadcasting from iPhone etc.
- Write unit tests based on the codebase. Use AI to suggest areas that are testable and write test code etc ✅
