//import Testing // doesnt work in GithubActions
import XCTest
import CryptoKit
import Foundation
@testable import PasskeyLib

class YourTestClassTests: XCTestCase {
   func test() {
      do {
         try Self.testPasskeyInitiation()
//         try Self.testPasskeyValidation()
         try Self.testCodable()
      } catch {
         Swift.print("error:  \(error.localizedDescription)")
      }
   }
}
extension YourTestClassTests {
   // 1. Test initiating a passkey
   private static func testPasskeyInitiation() throws {
      let pkData = PKData.init(
         relyingParty: "example.com",
         username: "alice",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )
      // Check credentialID bytes length
      let is32Bytes: Bool = Data(base64URLEncoded: pkData.credentialID)?.count == 32
      print("is32Bytes: \(is32Bytes ? "✅" : "🚫")")
      // #expect(is32Bytes) // CredentialID should be 32 bytes
      XCTAssertTrue(is32Bytes)
      
      // Check privkey length
      let privKey = try P256.Signing.PrivateKey.init(pemRepresentation: pkData.privateKey)
      let isPrivateKey32Bytes: Bool = privKey.rawRepresentation.count == 32 // Data(base64URLEncoded: pkData.privateKey)?.count
      print("isPrivateKey32Bytes: \(isPrivateKey32Bytes ? "✅" : "🚫")")
      //      #expect(isPrivateKey32Bytes) // Check the length of the private key (e.g., 32 bytes for P-256)
      XCTAssertTrue(isPrivateKey32Bytes)
      
      // Attempt to generate a public key from the private key
      let publicKey = privKey.publicKey // try? PKCrypto.generatePublicKey(from: Data(base64URLEncoded: pkData.privateKey) ?? Data())
      Swift.print("publicKey.rawRepresentation.count:  \(publicKey.rawRepresentation.count)")
      let isPublicKey64Bytes: Bool = publicKey.rawRepresentation.count == 64 // Data(base64URLEncoded: pkData.privateKey)?.count
      print("isPublicKey64Bytes: \(isPublicKey64Bytes ? "✅" : "🚫")")
      //      #expect(isPublicKey64Bytes)
      XCTAssertTrue(isPublicKey64Bytes)
   }
   // 2. Test Passkey Validation
   // - Fixme: ⚠️️ add invalidate case as well
   private static func testPasskeyValidation() throws {
      // Swift.print("testPasskeyValidation")
      let publicKey = Data(base64URLEncoded: "your-public-key-string")!
      let signature = Data(base64URLEncoded: "your-received-signature-string")!
      let challengeData = Data("your-challenge-string".utf8)
      let isValid = try PKValidator.validateSignature(publicKeyData: publicKey, signature: signature, data: challengeData)
      if isValid {
         print("✅ Authentication successful.")
      } else {
         print("🚫 Authentication failed.")
      }
      XCTAssertTrue(isValid)
   }
   // 3. test codable conversion
   private static func testCodable() throws {
      let pkData: PKData = .init(
         relyingParty: "example.com",
         username: "alice",
         userHandle: UUID().uuidString.data(using: .utf8)!
      )
      // Convert JSON Data to String
      let jsonString: String = try pkData.getJsonString()
      let newPkData: PKData = try .init(passKeyJsonString: jsonString)
      let equals = newPkData == pkData
      XCTAssertTrue(equals)
      print("equals: \(equals ? "✅" : "🚫")")
   }
}


