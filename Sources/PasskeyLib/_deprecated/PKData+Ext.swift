
 /// Encodes a `PKData` object into JSON format.
///
/// This method utilizes `JSONEncoder` to convert a `PKData` instance into JSON data,
/// applying the ISO 8601 date encoding strategy. If encoding fails, it captures the error
/// and returns `nil`.
///
/// - Parameter passkey: The `PKData` instance to be encoded.
/// - Returns: Optional `Data` object containing the JSON representation of `passkey`.
///            Returns `nil` if encoding fails.

 // extension PKData: Codable {
    // make this throwable?
    // func data(passkey: PKData) -> Data? {
    //     do {
    //         let encoder = JSONEncoder()
    //         encoder.dateEncodingStrategy = .iso8601
    //         let data = try encoder.encode(passkey)
    //     } catch {
    //         print("Failed to encode passkey data: \(error)")
    //         return nil
    //     }
    // }

    // make this throwable?
    // func passKey(data: Data) -> PasskeyData? {
    //     do {
    //         let decoder = JSONDecoder()
    //         decoder.dateDecodingStrategy = .iso8601
    //         let passkey = try decoder.decode(PasskeyData.self, from: data)
    //         return passkey
    //     } catch {
    //         print("Failed to decode passkey data: \(error)")
    //         return nil
    //     }
    // }
// }