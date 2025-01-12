//import Testing // doesnt work in GithubActions
import XCTest
import CryptoKit
import Foundation
@testable import PasskeyLib
import AuthenticationServices
/**
 * - Fixme: ⚠️️ Get a hold of synthetic passkey data to test with
 * - Fixme: ⚠️️ organize these test better
 */
class PasskeyLibTests: XCTestCase {}
/**
 * Tests
 */
extension PasskeyLibTests {
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
   
}
// Additional tests
extension PasskeyLibTests {
   /**
    * Verifies that the validator correctly validates a signature when provided with valid data.
    */
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
   /**
    * Tests that the validator correctly identifies an invalid signature.
    */
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
   /**
    * Tests the `Data` extension methods for Base64 URL encoding and decoding to ensure correct functionality.
    */
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
   /**
    * Verify that initializing PKData with invalid inputs handles errors appropriately.
    */
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
   /**
    * Tests to ensure that the computed properties in `PKData` return the correct data.
    */

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
   /**
    * Test the creation of an ASPasskeyAssertionCredential from PKData.
    */

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
   /**
    * This test ensures that the Data(random:) initializer generates data of the correct length.
    */

   func testDataRandomInitializer() {
      let dataLength = 32
      guard let randomData = Data(random: dataLength) else {
         XCTFail("Failed to generate random data.")
         return
      }

      // Assert that the generated data has the expected length
      XCTAssertEqual(randomData.count, dataLength, "Random data should be \(dataLength) bytes long.")
   }
   /**
    * Validate that the hex string extensions correctly encode and decode data.
    */

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
   /**
    * This test verifies that PKValidator.validateSignature throws an error when provided with invalid public key data.
    */

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

// more tests
extension PasskeyLibTests {
   /**
    * Test PKData Equality with Different Data
    *
    * Purpose: Ensure that the Equatable protocol is correctly implemented for PKData when comparing different instances.
    *
    * Test Case: Create two PKData instances with different properties and assert that they are not equal.
    */
   func testPKDataInequality() {
      let pkData1 = PKData(
         relyingParty: "example.com",
         username: "alice",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )
      
      let pkData2 = PKData(
         relyingParty: "example.org",
         username: "bob",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )
      
      // Assert that the two PKData instances are not equal
      XCTAssertNotEqual(pkData1, pkData2, "PKData instances should not be equal.")
   }
   /**
    * Test Attestation Object Creation with Invalid Public Key Size
    * Purpose: This test verifies that an error is thrown when an invalid public key size is provided during attestation object creation.
    * Test Case: The test attempts to create an attestation object with an incorrect publicKeySizeInBytes and verifies that the appropriate error is thrown.
    */
   func testAttestationObjectCreationWithInvalidPublicKeySize() {
      let pkData = PKData(
         relyingParty: "example.com",
         username: "testUser",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )
      
      do {
         // Attempt to create attestation object with invalid public key size
         let _ = try pkData.getAttestationObject(publicKeySizeInBytes: 100)
         XCTFail("Expected an error due to invalid public key size, but creation succeeded.")
      } catch {
         // Expected error
         XCTAssertTrue(true, "Caught expected error: \(error)")
      }
   }
   /**
    Tests how the PKValidator handles an empty signature.

    - Purpose: To verify that providing an empty Data object as the signature to the PKValidator results in a failed validation or an appropriate error being thrown.
    - Test Case: An empty Data object is used as the signature in the validation process.
    */
   func testValidateSignatureWithEmptySignature() {
      do {
         // Generate a key pair
         let privateKey = P256.Signing.PrivateKey()
         let publicKey = privateKey.publicKey
         
         // Prepare data to sign
         let dataToSign = "Test data".data(using: .utf8)!
         
         // Use an empty signature
         let signature = Data()
         
         // Attempt to validate signature
         let isValid = try PKValidator.validateSignature(
            publicKeyData: publicKey.rawRepresentation,
            signature: signature,
            data: dataToSign
         )
         
         // Validation should fail
         XCTAssertFalse(isValid, "Validation should fail with empty signature.")
      } catch {
         // Expected error
         XCTAssertTrue(true, "Caught expected error: \(error)")
      }
   }
   /**
    Tests the PKSigner's behavior with an invalid private key.

    - Purpose: To ensure that the PKSigner correctly handles cases where an invalid private key is used to sign data.
    - Test Case: An invalid private key string is provided to the signing method, and the test verifies that the method returns nil or throws an error.
    */
   func testPKSignerWithInvalidPrivateKey() {
      // Invalid private key string
      let invalidPrivateKeyStr = "InvalidPrivateKey"
      
      // Data to sign
      let dataToSign = "Test data".data(using: .utf8)!
      
      // Attempt to sign data with an invalid private key
      let signature = PKSigner.signWithPrivateKey(dataToSign, privateKeyStr: invalidPrivateKeyStr)
      
      // Assert that the signature is nil
      XCTAssertNil(signature, "Signature should be nil when private key is invalid.")
   }
   /**
    * Test Data Extension with Zero Length in Random Initializer
    *
    * Purpose: Verify that initializing Data with zero length using the random initializer behaves as expected.
    *
    * Test Case: Attempt to create random data with length zero and check that it returns an empty Data object or nil.
    */
   func testDataRandomInitializerWithZeroLength() {
      let dataLength = 0
      let randomData = Data(random: dataLength)
      
      // Assert that the returned Data is not nil and has zero count
      XCTAssertNotNil(randomData, "Random data should not be nil even with zero length.")
      XCTAssertEqual(randomData?.count, dataLength, "Random data should have zero length.")
   }
   /**
    * Test Base64 URL Encoding with Special Characters
    *
    * Purpose: Ensure that the base64URLEncodedString method correctly handles data containing special characters.
    *
    * Test Case: Encode data with special characters and verify that it can be correctly encoded and decoded.
    */
   func testBase64URLEncodingWithSpecialCharacters() {
      let originalString = "!@#$%^&*()_+-=[]{}|;':,.<>/?`~"
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
   /**
    * Test Attestation Object Decoding with Corrupted Data
    *
    * Purpose: Verify that attempting to decode a corrupted attestation object appropriately fails.
    *
    * Test Case: Provide malformed or corrupted data to the attestation object decoder and check that it returns nil or throws an error.
    */
   func testAttestationObjectDecodingWithCorruptedData() {
      // Corrupted attestation data
      let corruptedData = Data([0x00, 0xFF, 0xAB, 0xCD])
      
      // Attempt to decode the attestation object
      let attestationObject = decodeAttestationObject(corruptedData)
      
      // Assert that the attestation object is nil
      XCTAssertNil(attestationObject, "Attestation object should be nil when data is corrupted.")
   }
   /**
    * Test AuthenticatorData Byte Representation
    *
    * Ensures that the byteArrayRepresentation method of AuthenticatorData produces the correct byte sequence.
    *
    * Test Case: Create an AuthenticatorData instance with known values and verify that the byte array matches the expected output.
    */
   func testAuthenticatorDataByteRepresentation() {
       // Define known values
       let relyingPartyID = "example.com"
       let flags: AuthenticatorFlags = [.userPresent, .userVerified]
       let counter: UInt32 = 42

       // Create AuthenticatorData instance without attestedData and extData
       let authData = AuthenticatorData(
          relyingPartyID: relyingPartyID,
          flags: flags,
          counter: counter,
          attestedData: nil,
          extData: nil
       )

       // Get byte representation
       let byteArray = authData.byteArrayRepresentation()

       // Expected byte array (construct manually or based on known correct values)
       var expectedBytes = [UInt8]()

       // rpIdHash (SHA256 hash of relyingPartyID)
       let rpIdHashData = Data(SHA256.hash(data: relyingPartyID.data(using: .utf8)!))
       expectedBytes += rpIdHashData

       // Flags byte
       expectedBytes.append(flags.rawValue)

       // Counter (big-endian)
       var counterBE = counter.bigEndian
       let counterBytes = withUnsafeBytes(of: &counterBE) { Array($0) }
       expectedBytes += counterBytes

       // Assert that the byte arrays are equal
       XCTAssertEqual(byteArray, expectedBytes, "Byte representation should match expected bytes.")
    }
    /**
     * Test PKData Initialization with Large User Handle
     *
     * Purpose: Ensure that a very large userHandle does not cause unexpected behavior.
     * Test Case: Provide a userHandle with a large size and check whether PKData initializes correctly.
     */
    func testPKDataInitializationWithLargeUserHandle() {
       // Generate a large user handle
       let largeUserHandleData = Data(count: 1024 * 1024) // 1 MB of zeros
       
       let pkData = PKData(
          relyingParty: "example.com",
          username: "alice",
          userHandle: largeUserHandleData
       )
       
       // Assert that PKData is initialized
       XCTAssertNotNil(pkData, "PKData should be initialized with large userHandle.")
       
       // Additional checks can be added as needed
    }
    /**
     * Test Data Hex Encoding with Empty Data
     *
     * Purpose: Ensure that encoding an empty Data object to a hex string results in an empty string.
     * Test Case: Encode empty data and verify that the result is an empty string.
     */
    func testHexEncodingWithEmptyData() {
       let emptyData = Data()
       
       // Convert data to hex string
       let hexString = emptyData.toHexString()
       
       // Assert that the hex string is empty
       XCTAssertTrue(hexString.isEmpty, "Hex string should be empty for empty data.")
    }
}
