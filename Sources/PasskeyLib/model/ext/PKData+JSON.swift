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
      let jsonData = try JSONEncoder().encode(self)
      guard let jsonString = String(data: jsonData, encoding: .utf8) else {
         throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "Failed to convert data to JSON string"))
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
      guard let jsonData = passKeyJsonString.data(using: .utf8) else {
         throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Failed to convert JSON string to Data"))
      }
      self = try JSONDecoder().decode(PKData.self, from: jsonData)
   }
}
