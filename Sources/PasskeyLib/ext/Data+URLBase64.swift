import Foundation

public extension Data {
    /**
     * Initializes a Data object from a Base64 URL encoded string.
     * - Description: This initializer takes a URL-safe Base64 encoded string, converts it to a standard Base64 format, and then initializes a Data object from that standard Base64 string.
     * - Parameter string: A URL-safe Base64 encoded string.
     */
    init?(base64URLEncoded string: String) {
        /**
         * Convert URL-safe Base64 string to standard Base64 string:
         * 1. Replace '-' with '+' to revert URL-safe encoding.
         * 2. Replace '_' with '/' to revert URL-safe encoding.
         */
        let normalizedBase64String = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            .appendingPaddingForBase64() // Ensure proper padding for valid Base64 decoding.
        // Initialize the Data object using the standard Base64 encoded string.
        self.init(base64Encoded: normalizedBase64String)
    }
    /**
     * Returns a Base64 URL encoded string from the Data.
     * - Description: This method encodes the data into a standard Base64 string and then converts it into a URL-safe format.
     * - Returns: A URL-safe Base64 encoded string.
     */
    func base64URLEncodedString() -> String {
        // Encode the data to a standard Base64 string.
        let base64EncodedString = self.base64EncodedString()
        // Convert standard Base64 string to a URL-safe Base64 string:
        return base64EncodedString
            // 1. Replace '+' with '-' to make it URL-safe.
            .replacingOccurrences(of: "+", with: "-")
            // 2. Replace '/' with '_' to make it URL-safe.
            .replacingOccurrences(of: "/", with: "_")
            // 3. Remove '=' as padding is not typically used in URL-safe encoding.
            .replacingOccurrences(of: "=", with: "")
    }
}

private extension String {
    /**
     * Appends the necessary '=' padding to the end of a Base64 encoded string to make its length a multiple of 4.
     * - Description: This is required because Base64 encoding expects the length of the string to be divisible by 4.
     * - Returns: A padded Base64 encoded string if necessary.
     */
    func appendingPaddingForBase64() -> String {
        // Calculate the required padding length.
        let paddingLength = (4 - self.count % 4) % 4
        // Append '=' characters as padding to the end of the string.
        return self + String(repeating: "=", count: paddingLength)
    }
}




//public func base64URLEncodedString() -> String {
//   let base64String = self.base64EncodedString()
//   let base64URLString =
//   base64String
//      .replacingOccurrences(of: "+", with: "-")
//      .replacingOccurrences(of: "/", with: "_")
//      .trimmingCharacters(in: CharacterSet(charactersIn: "="))
//   return base64URLString
//}

/// Initializes `Data` by decoding a base64 URL encoded string.
/// - Parameter base64URLEncoded: The base64 URL encoded string.
/// - Returns: An optional `Data` instance if the string is valid and successfully decoded, otherwise `nil`.
//public init?(base64URLEncoded: String) {
//   let paddedBase64 =
//   base64URLEncoded
//      .replacingOccurrences(of: "-", with: "+")
//      .replacingOccurrences(of: "_", with: "/")
//   // Adjust the string to ensure it's a multiple of 4 for valid base64 decoding
//   let paddingLength = (4 - paddedBase64.count % 4) % 4
//   let paddedBase64String = paddedBase64 + String(repeating: "=", count: paddingLength)
//   guard let data = Data(base64Encoded: paddedBase64String) else {
//      return nil
//   }
//   self = data
//}
