import Foundation

extension PKData {
   /**
    * - Fixme: ⚠️️ add doc
    */
   public func getJsonString() throws -> String {
      let data: Data = try JSONEncoder().encode(self)
      // Convert JSON Data to String
      guard let jsonString = String(data: data, encoding: .utf8) else {
         throw NSError(domain: "err json str - Failed to convert data to JSON string", code: 0)
      }
      return jsonString
   }
   /**
    * - Fixme: ⚠️️ add doc
    */
   public init(passKeyJsonString: String) throws {
      // Convert jsonString back to Data
      guard let jsonData = passKeyJsonString.data(using: .utf8) else {
         throw(NSError.init(domain: "Failed to convert JSON string back to Data", code: 0))
      }
      do {
         self = try JSONDecoder().decode(PKData.self, from: jsonData)
      } catch {
         throw(NSError.init(domain: "Failed to convert Data back to pkData - error: \(error.localizedDescription)", code: 0))
      }
   }
}
