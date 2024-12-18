import Foundation
/**
 * JSON
 */
extension PKData {
   /**
    * Converts the PKData object to a JSON string representation.
    * - Description: This method encodes the PKData object into JSON format using JSONEncoder.
    * - Returns: A string containing the JSON representation of the PKData object.
    * - Throws: An error if the encoding process fails or if the data cannot be converted to a string.
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
    * Initializes a PKData object from a JSON string representation.
    * - Description: This method decodes a JSON string into a PKData object using JSONDecoder.
    * - Parameter passKeyJsonString: A string containing the JSON representation of a PKData object.
    * - Throws: An error if the decoding process fails or if the string cannot be converted to data.
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
