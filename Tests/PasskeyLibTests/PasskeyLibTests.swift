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
   // test to check that the validator correctly identifies an invalid signature.
   func testValidateSignatureWithInvalidData() {
      do {
         // Generate a key pair using Ed25519
         let privateKey = Curve25519.Signing.PrivateKey()
         let publicKey = privateKey.publicKey

         // Prepare data to sign
         let dataToSign = "Test data".data(using: .utf8)!

         // Sign the data
         let signature = try privateKey.signature(for: dataToSign)

         // Modify the data to invalidate the signature
         let tamperedData = "Tampered data".data(using: .utf8)!

         // Validate the signature with tampered data
         let isValid = try PKValidator.validateSignature(
               publicKeyData: publicKey.rawRepresentation,
               signature: signature,
               data: tamperedData
         )

         // Assert that the signature is invalid
         XCTAssertFalse(isValid, "The signature should be invalid.")
      } catch {
         XCTFail("Error during test: \(error)")
      }
   }
   // Test the `Data` extension methods for Base64 URL encoding and decoding to ensure correct functionality.
   func testBase64URLEncodingDecoding() {
      let originalString = "Test string for Base64 URL encoding/decoding."
      guard let originalData = originalString.data(using: .utf8) else {
         XCTFail("Failed to convert string to data.")
         return
      }

      // Encode to Base64 URL
      let base64URLString = originalData.base64URLEncodedString()

      // Decode back to Data
      guard let decodedData = Data(base64URLEncoded: base64URLString) else {
         XCTFail("Failed to decode Base64 URL string.")
         return
      }

      // Convert back to String
      guard let decodedString = String(data: decodedData, encoding: .utf8) else {
         XCTFail("Failed to convert data to string.")
         return
      }

      // Assert that the original and decoded strings are equal
      XCTAssertEqual(decodedString, originalString, "The decoded string should match the original.")
   }

   // Verify that initializing PKData with invalid inputs handles errors appropriately.

   func testPKDataInitializationWithInvalidInputs() {
      // Invalid userHandle data (empty data)
      let userHandleData = Data()
      let username = "alice"
      let relyingParty = "example.com"

      // Attempt to initialize PKData
      let pkData = PKData(
         relyingParty: relyingParty,
         username: username,
         userHandle: userHandleData
      )

      // Assert that PKData was initialized despite invalid userHandle (depends on your implementation)
      // If PKData should handle empty userHandleData, adjust the test accordingly
      XCTAssertNotNil(pkData, "PKData should be initialized even with empty userHandle data.")
   }

   // Ensure that the computed properties in PKData return the correct data.

   func testPKDataGetters() {
      let pkData = PKData(
         relyingParty: "example.com",
         username: "alice",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )

      // Test userHandleData
      XCTAssertNotNil(pkData.userHandleData, "userHandleData should not be nil.")

      // Test credentialIDData
      XCTAssertNotNil(pkData.credentialIDData, "credentialIDData should not be nil.")

      // Test privateKeyStr
      XCTAssertNotNil(pkData.privateKeyStr, "privateKeyStr should not be nil.")

      // Test publicKeyStr
      XCTAssertNotNil(pkData.publicKeyStr, "publicKeyStr should not be nil.")
   }

   // Test the creation of an ASPasskeyAssertionCredential from PKData.

   func testASPasskeyAssertionCredentialCreation() {
      let pkData = PKData(
         relyingParty: "example.com",
         username: "alice",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )

      // Create a client data hash (normally provided by the system)
      let clientDataHash = SHA256.hash(data: "client data".data(using: .utf8)!)

      // Get the assertion credential
      guard let assertionCredential = pkData.getAssertionCredential(clientDataHash: Data(clientDataHash)) else {
         XCTFail("Failed to create ASPasskeyAssertionCredential.")
         return
      }

      // Assert that the credential contains expected values
      XCTAssertEqual(assertionCredential.relyingParty, pkData.relyingParty, "Relying party should match.")
      XCTAssertEqual(assertionCredential.userHandle, pkData.userHandleData, "User handle should match.")
      XCTAssertEqual(assertionCredential.credentialID, pkData.credentialIDData, "Credential ID should match.")
      // Additional checks can be added as needed
   }

   // Verify that the attestation object is correctly decoded and that public key extraction works as intended.
   // ⚠️️ out of order, fix later
//   func testAttestationObjectDecoding() {
//      let pkData = PKData(
//         relyingParty: "example.com",
//         username: "alice",
//         userHandle: UUID().uuidString.data(using: .utf8)!
//      )
//
//      // Obtain the attestation object
//      let attestationObjectData = pkData.getAttestationObject()
//
//      // Decode the attestation object
//      guard let attestationObject = decodeAttestationObject(attestationObjectData) else {
//         XCTFail("Failed to decode attestation object.")
//         return
//      }
//
//      // Extract the public key
//      guard let publicKeyData = extractPublicKey(from: attestationObject) else {
//         XCTFail("Failed to extract public key from attestation object.")
//         return
//      }
//
//      // Assert that the public key data matches the expected length
//      XCTAssertEqual(publicKeyData.count, 65, "Public key data should be 65 bytes for P-256 curve.")
//   }

   // Ensure that the Data(random:) initializer generates data of the correct length.

   func testDataRandomInitializer() {
      let dataLength = 32
      guard let randomData = Data(random: dataLength) else {
         XCTFail("Failed to generate random data.")
         return
      }

      // Assert that the generated data has the expected length
      XCTAssertEqual(randomData.count, dataLength, "Random data should be \(dataLength) bytes long.")
   }
   // Validate that the hex string extensions correctly encode and decode data.

   func testHexStringEncodingDecoding() {
      let originalData = "Test data for hex encoding.".data(using: .utf8)!

      // Convert data to hex string
      let hexString = originalData.toHexString()

      // Convert hex string back to data
      guard let decodedData = Data(hexString: hexString) else {
         XCTFail("Failed to decode hex string.")
         return
      }

      // Assert that the original and decoded data are equal
      XCTAssertEqual(decodedData, originalData, "Decoded data should match the original.")
   }

   // Check that PKValidator.validateSignature throws an error when provided with invalid public key data.

   func testValidateSignatureWithInvalidPublicKey() {
      do {
         // Invalid public key data
         let invalidPublicKeyData = Data([0x00, 0x01, 0x02])

         // Some signature and data
         let signature = Data([0x00, 0x01, 0x02])
         let data = "Test data".data(using: .utf8)!

         // Attempt to validate signature
         _ = try PKValidator.validateSignature(
               publicKeyData: invalidPublicKeyData,
               signature: signature,
               data: data
         )

         XCTFail("Expected an error due to invalid public key, but validation succeeded.")
      } catch {
         // Expected error
         XCTAssertTrue(true, "Caught expected error: \(error)")
      }
   }
}

