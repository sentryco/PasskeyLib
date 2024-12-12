import Foundation

extension PKData {
   public var userHandleData: Data? {
      .init(base64URLEncoded: self.userHandle)
   }
   public var credentialIDData: Data? {
      .init(base64URLEncoded: self.credentialID)
   }
}
