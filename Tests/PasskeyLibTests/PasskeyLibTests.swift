//import Testing // doesnt work in GithubActions
import XCTest
import CryptoKit
import Foundation
@testable import PasskeyLib
/**
 * - Fixme: ⚠️️ Get a hold of synthetic passkey data to test with
 */
class YourTestClassTests: XCTestCase {
   func test() {
      do {
         try Self.testPasskeyInitiation()
         // try Self.testPasskeySignatureValidation()
         try Self.testCodable()
      } catch {
         Swift.print("error:  \(error.localizedDescription)")
      }
   }
}
/**
 * Tests
 */
extension YourTestClassTests {
   /**
    * Test initiating a passkey
    */
   private static func testPasskeyInitiation() throws {
       let pkData = PKData(
           relyingParty: "example.com",
           username: "alice",
           userHandle: UUID().uuidString.data(using: .utf8)!
       )

       // Helper function to check data length and print result
       func checkDataLength(_ data: Data, expectedLength: Int, description: String) {
           let isExpectedLength = data.count == expectedLength
           print("\(description): \(isExpectedLength ? "✅" : "🚫")")
           XCTAssertTrue(isExpectedLength, "\(description) should be \(expectedLength) bytes")
       }

       // Check credentialID bytes length
       if let credentialIDData = Data(base64URLEncoded: pkData.credentialID) {
           checkDataLength(credentialIDData, expectedLength: 32, description: "CredentialID")
       } else {
           XCTFail("Failed to decode CredentialID")
       }

       // Check private key length
       let privKey = try P256.Signing.PrivateKey(pemRepresentation: pkData.privateKey)
       checkDataLength(privKey.rawRepresentation, expectedLength: 32, description: "Private Key")

       // Generate public key from the private key and check length
       let publicKey = privKey.publicKey
       Swift.print("publicKey.rawRepresentation.count: \(publicKey.rawRepresentation.count)")
       checkDataLength(publicKey.rawRepresentation, expectedLength: 64, description: "Public Key")
   }
   /**
    * Test Passkey Signature Validation
    * - Fixme: ⚠️️ add invalidate case as well
    */
   private static func testPasskeySignatureValidation() throws {
      // Swift.print("testPasskeyValidation")
      
      // Prepare test data
      let publicKeyBase64URL = "your-public-key-string"
      let signatureBase64URL = "your-received-signature-string"
      let challengeString = "your-challenge-string"

      // Decode base64URL encoded strings
      guard let publicKeyData = Data(base64URLEncoded: publicKeyBase64URL) else {
         XCTFail("Invalid public key base64URL string.")
         return
      }
      guard let signatureData = Data(base64URLEncoded: signatureBase64URL) else {
         XCTFail("Invalid signature base64URL string.")
         return
      }
      let challengeData = Data(challengeString.utf8)

      // Validate signature
      let isValid = try PKValidator.validateSignature(
         publicKeyData: publicKeyData,
         signature: signatureData,
         data: challengeData
      )

      // Output the result
      let resultMessage = isValid ? "✅ Authentication successful." : "🚫 Authentication failed."
      print(resultMessage)

      // Assert the result
      XCTAssertTrue(isValid)
   }
   /**
    * Test codable conversion
    */
   private static func testCodable() throws {
      // Initialize PKData
      let pkData = PKData(
         relyingParty: "example.com",
         username: "alice",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )
      // Serialize PKData to JSON string
      let jsonString = try pkData.getJsonString()
      // Deserialize JSON string back to PKData
      let newPkData = try PKData(passKeyJsonString: jsonString)
      // Verify that the original and deserialized PKData are equal
      XCTAssertEqual(newPkData, pkData)
      print("equals: \(newPkData == pkData ? "✅" : "🚫")")
   }
}
// Additional tests
extension YourTestClassTests {
   //  correctly validates a signature when provided with valid data.
   func testValidateSignatureWithValidData() {
      do {
         // Generate a key pair using Ed25519
         let privateKey = Curve25519.Signing.PrivateKey()
         let publicKey = privateKey.publicKey

         // Prepare data to sign
         let dataToSign = "Test data".data(using: .utf8)!

         // Sign the data
         let signature = try privateKey.signature(for: dataToSign)

         // Validate the signature using the raw representations
         let isValid = try PKValidator.validateSignature(
               publicKeyData: publicKey.rawRepresentation,
               signature: signature,
               data: dataToSign
         )

         // Assert that the signature is valid
         XCTAssertTrue(isValid, "The signature should be valid.")
      } catch {
         XCTFail("Error during test: \(error)")
      }
   }
}

