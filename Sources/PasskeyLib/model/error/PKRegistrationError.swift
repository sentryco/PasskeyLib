import Foundation
/**
 * - Description: PKRegistrationError represents errors that can occur during passkey registration.
 * - Fixme: ⚠️️ add more cases later: https://github.com/tkhq/swift-sdk/blob/35a3f203d406eaaf64cc647f4c001deddb69c365/Sources/Shared/PasskeyManager.swift#L29
 */
enum PKRegistrationError: LocalizedError {
   /// Represents the error when an unsupported passkey algorithm is encountered.
   case unsupportedAlgorithm

   /// A localized description of the error.
   var errorDescription: String? {
      switch self {
      case .unsupportedAlgorithm:
         return "Unsupported passkey algorithm"
      }
   }
}
// https://github.com/tkhq/swift-sdk/blob/35a3f203d406eaaf64cc647f4c001deddb69c365/Sources/Shared/PasskeyManager.swift
// - Fixme: ⚠️️ add the bellow:
//public enum PasskeyRegistrationError: Error {
//   case missingRPID
//   case unexpectedCredentialType
//   case invalidClientDataJSON
//   case registrationFailed(Error)
//   case invalidAttestation
//}

//public enum PasskeyManagerError: Error {
//   case unknownAuthorizationType
//   case authorizationFailed(Error)
//}
