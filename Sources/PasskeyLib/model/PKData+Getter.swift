import Foundation

extension PKData {
   /**
    * Retrieves the user handle as `Data`.
    * - Description: This computed property converts the base64 URL encoded user handle string to `Data`.
    * - Returns: The user handle as `Data` or `nil` if the conversion fails.
    */
   public var userHandleData: Data? {
      .init(base64URLEncoded: self.userHandle)
   }
   /**
    * Retrieves the credential ID as `Data`.
    * - Description: This computed property converts the base64 URL encoded credential ID string to `Data`.
    * - Returns: The credential ID as `Data` or `nil` if the conversion fails.
    */
   public var credentialIDData: Data? {
      .init(base64URLEncoded: self.credentialID)
   }
}
