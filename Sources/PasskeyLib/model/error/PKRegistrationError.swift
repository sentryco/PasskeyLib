import Foundation
/**
 * - Fixme: ⚠️️ add more cases later: https://github.com/tkhq/swift-sdk/blob/35a3f203d406eaaf64cc647f4c001deddb69c365/Sources/Shared/PasskeyManager.swift#L29
 */
enum PKRegistrationError: LocalizedError {
   case unsupportedAlgorithm
   var errorDescription: String? {
      switch self {
      case .unsupportedAlgorithm: "Unsupported passkey algorithm"
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
