import XCTest
import CryptoKit
import Foundation
@testable import PasskeyLib
import AuthenticationServices

// json tests

extension PasskeyLibTests {
    /**
     * Verifies that a valid `PKData` instance can be serialized to a non-empty JSON string.
     *
     * Initializes `pkData` with valid data and asserts that the resulting `jsonString` is not empty.
     */
    func testGetJsonString_Success() throws {
        // Given: a valid PKData instance
            // Start of Selection
            let pkData = PKData(
                relyingParty: "example.com",
                username: "testUser",
                userHandle: UUID().uuidString.data(using: .utf8)!
            )
        
        // When: converting to JSON string
        let jsonString = try pkData.getJsonString()
        
        // Then: the JSON string should not be empty
        XCTAssertFalse(jsonString.isEmpty, "JSON string should not be empty")
        
        // Optionally, verify that the JSON string contains expected keys/values
        // For example:
        // XCTAssertTrue(jsonString.contains("\"someKey\":\"someValue\""))
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
   /**
    * Test PKData JSON Serialization with Invalid Data
    *
    * Ensures that attempting to serialize or deserialize PKData with invalid JSON data properly throws errors.
    *
    * Test Case: Provide malformed JSON strings to the PKData initializer and check that it throws the expected errors.
    */
   func testPKDataSerializationWithInvalidJSON() {
      do {
         // Malformed JSON string
         let invalidJsonString = "{ invalid json }"
         
         // Attempt to initialize PKData with invalid JSON
         _ = try PKData(passKeyJsonString: invalidJsonString)
         
         XCTFail("Initialization should have failed with invalid JSON.")
      } catch {
         // Expected error
         XCTAssertTrue(true, "Caught expected error: \(error)")
      }
   }
    /**
    * Ensures that serializing and then deserializing a `PKData` instance yields an equivalent object.
    * Implementation: Serialize `originalPKData` to `jsonString`, deserialize it back to `deserializedPKData`, and assert that both instances are equal.
    */
    func testSerializationDeserialization() throws {
        // Given: a valid PKData instance
        let originalPKData = PKData(
            relyingParty: "example.com",
            username: "alice",
            userHandle: UUID().uuidString.data(using: .utf8)!
        )
        
        // When: serialize to JSON string and deserialize back to PKData
        let jsonString = try originalPKData.getJsonString()
        let deserializedPKData = try PKData(passKeyJsonString: jsonString)
        
        // Then: original and deserialized PKData should be equal
        // Ensure PKData conforms to Equatable for this assertion
        XCTAssertEqual(originalPKData, deserializedPKData, "Original and deserialized PKData should be equal")
    }
    /**
    * Purpose: Confirm that a valid JSON string can be deserialized into a PKData instance with expected properties.
    * Implementation: Provide a valid JSON string matching your PKData structure and assert that the properties of the resulting pkData match expected values.
    */
    func testInitWithJsonString_Success() throws {
        // Given: specific test values
        let relyingParty = "example.com"
        let username = "alice"
        let userHandleData = UUID().uuidString.data(using: .utf8)!
        let credentialIDData = "credential-id-test".data(using: .utf8)!
        let privateKey = "test-private-key"
        
        // Convert data to base64URL encoded strings
        let userHandleBase64URL = userHandleData.base64URLEncodedString()
        let credentialIDBase64URL = credentialIDData.base64URLEncodedString()
        
        // Build the JSON string
        let jsonString = """
        {
            "relyingParty": "\(relyingParty)",
            "username": "\(username)",
            "userHandle": "\(userHandleBase64URL)",
            "credentialID": "\(credentialIDBase64URL)",
            "privateKey": "\(privateKey)"
        }
        """
        
        // When: initializing PKData from JSON string
        let pkData = try PKData(passKeyJsonString: jsonString)
        
        // Then: pkData should have expected properties
        XCTAssertEqual(pkData.relyingParty, relyingParty)
        XCTAssertEqual(pkData.username, username)
        XCTAssertEqual(pkData.userHandleData, userHandleData)
        XCTAssertEqual(pkData.credentialIDData, credentialIDData)
        XCTAssertEqual(pkData.privateKey, privateKey)
    }
    /**
    Verifies that initializing `PKData` with an invalid JSON string results in a `DecodingError`.

    Uses an obviously invalid JSON string and asserts that an error is thrown during initialization.
    */
    func testInitWithJsonString_InvalidJson() {
        // Given: an invalid JSON string
        let jsonString = "{ invalid json }"
        
        // Then: initialization should throw an error
        XCTAssertThrowsError(try PKData(passKeyJsonString: jsonString)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}

