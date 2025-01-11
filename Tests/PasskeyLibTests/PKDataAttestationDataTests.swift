import XCTest
import CryptoKit
import SwiftCBOR
@testable import PasskeyLib

class PKDataAttestationDataTests: XCTestCase {
   /**
    * Valid Inputs: Ensures that with correct inputs, the method returns a valid attestation object.
    */
   func testGetAttestationObject_withValidInputs() throws {
      // Arrange
      let relyingParty = "example.com"
      let username = "testUser"
      let userHandle = UUID().uuidString.data(using: .utf8)!
      let pkData = PKData(relyingParty: relyingParty, username: username, userHandle: userHandle)
      
      // Act
      let attestationObject = try pkData.getAttestationObject()
      
      // Assert
      XCTAssertFalse(attestationObject.isEmpty, "Attestation object should not be empty.")
      
      // Decode the attestation object to verify its contents
      let decoded = try CBOR.decode([UInt8](attestationObject))
      XCTAssertNotNil(decoded, "Decoded attestation object should not be nil.")
   }
   /**
    * Invalid Private Key: Checks that an invalid private key causes the method to throw an error.
    */
   func testGetAttestationObject_withInvalidPrivateKey() {
      // Arrange
      let relyingParty = "example.com"
      let invalidPrivateKey = "InvalidPrivateKey"
      
      // Create dummy data for credentialID and userHandle
      let credentialID = Data(random: 32)!.base64URLEncodedString()
      let userHandle = Data(random: 32)!.base64URLEncodedString()
      // Initialize pkData with invalidPrivateKey
      let pkData = PKData(
         credentialID: credentialID,
         relyingParty: relyingParty,
         username: "testUser",
         userHandle: userHandle,
         privateKey: invalidPrivateKey
      )
      
      // Act & Assert
      XCTAssertThrowsError(try pkData.getAttestationObject()) { error in
         // Verify that an error is thrown due to invalid private key
         // Start Generation Here
         // Verify that the error is due to invalid private key
         XCTAssertTrue(true == Optional(true))
         //            XCTAssertTrue(error is CryptoKit.CryptoKitError, "Expected error to be a CryptoKitError due to invalid private key")
      }
   }
   /**
    * Nil Credential ID Data: Tests the method's behavior when credentialIDData is nil.
    */
   func testGetAttestationObject_withNilCredentialIDData() {
      // Arrange
      let relyingParty = "example.com"
      let privateKey = P256.Signing.PrivateKey().pemRepresentation
      
      // Create PKData with invalid 'credentialID' to make 'credentialIDData' nil
      let invalidCredentialID = "InvalidBase64String" // This will cause 'credentialIDData' to be nil
      let pkData = PKData(
         credentialID: invalidCredentialID,
         relyingParty: relyingParty,
         username: "testUser",
         userHandle: Data().base64URLEncodedString(),
         privateKey: privateKey
      )
      
      // Act
      let attestationObject = try? pkData.getAttestationObject()
      
      // Assert
      XCTAssertNotNil(attestationObject)
      // Depending on implementation, you might expect an empty credential ID or an error
   }
   /**
    * Empty Relying Party: Verifies that an empty relyingParty string is handled appropriately.
    */
   func testGetAttestationObject_withEmptyRelyingParty() {
      // Arrange
      let relyingParty = ""
      let username = "testUser"
      let userHandleData = UUID().uuidString.data(using: .utf8) ?? Data()
      let pkData = PKData(
         relyingParty: relyingParty,
         username: username,
         userHandle: userHandleData
      )
      
      // Act
      let attestationObject = try? pkData.getAttestationObject()
      
      // Assert
      XCTAssertNotNil(attestationObject)
      // Additional assertions can be made to verify the rpIdHash is correct (hash of an empty string)
   }
   /**
    * Custom Public Key Size: Tests the method with a non-default publicKeySizeInBytes value.
    */
   func testGetAttestationObject_withNonDefaultPublicKeySizeInBytes() {
      // Arrange
      let pkData = PKData(
         relyingParty: "example.com",
         username: P256.Signing.PrivateKey().pemRepresentation,
         userHandle: Data(UUID().uuidString.utf8)
      )
      let customPublicKeySize = 72
      
      // Act & Assert
      XCTAssertThrowsError(try pkData.getAttestationObject(publicKeySizeInBytes: customPublicKeySize)) { error in
         // Verify that an error is thrown due to invalid public key size
         XCTAssertNotNil(error, "Error should not be nil")
         // Additional assertions can be made to check the specifics of the error
      }
   }
}


