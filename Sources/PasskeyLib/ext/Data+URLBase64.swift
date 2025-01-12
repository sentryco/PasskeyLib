import Foundation
/**
 * Data+URLBase64
 */
public extension Data {
    /**
     * Initializes a Data object from a Base64 URL encoded string.
     * - Description: This initializer takes a URL-safe Base64 encoded string, converts it to a standard Base64 format, and then initializes a Data object from that standard Base64 string.
     * - Parameter string: A URL-safe Base64 encoded string.
     */
    init?(base64URLEncoded string: String) {
        // Initialize the Data object using the normalized Base64 encoded string.
        self.init(base64Encoded: string.base64normalized())
    }
    /**
     * Returns a Base64 URL encoded string from the Data.
     * - Description: This method encodes the data into a standard Base64 string and then converts it into a URL-safe format.
     * - Returns: A URL-safe Base64 encoded string.
     */
    func base64URLEncodedString() -> String {
        // Encode the data to a standard Base64 string and normalize it to URL-safe Base64.
        return self.base64EncodedString().base64URLnormalized()
    }
}
/**
 * String extension for Base64 URL normalization.
 */
private extension String {
    /**
        * Convert URL-safe Base64 string to standard Base64 string:
        * 1. Replace '-' with '+' to revert URL-safe encoding.
        * 2. Replace '_' with '/' to revert URL-safe encoding.
        */
    func base64normalized() -> String {
        return self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            .appendingPaddingForBase64() // Ensure proper padding for valid Base64 decoding.
    }
   /**
    * Converts a standard Base64 encoded string to a URL-safe Base64 encoded string.
    * - Description: This method replaces characters to make the Base64 string URL-safe.
    * - Returns: A URL-safe Base64 encoded string.
    */
   func base64URLnormalized() -> String {
      return self
      // 1. Replace '+' with '-' to make it URL-safe.
         .replacingOccurrences(of: "+", with: "-")
      // 2. Replace '/' with '_' to make it URL-safe.
         .replacingOccurrences(of: "/", with: "_")
      // 3. Remove '=' as padding is not typically used in URL-safe encoding.
         .replacingOccurrences(of: "=", with: "")
   }
}
/**
 * String ext
 */
private extension String {
    /**
     * Appends the necessary '=' padding to the end of a Base64 encoded string to make its length a multiple of 4.
     * - Description: Base64 encoding requires that the length of the string be divisible by 4. This method ensures that by appending the necessary '=' characters.
     * - Returns: A Base64 encoded string padded as necessary.
     */
    func appendingPaddingForBase64() -> String {
        // Calculate the number of padding characters needed.
        let requiredPadding = (4 - self.count % 4) % 4
        // If no padding is needed, return the original string.
        guard requiredPadding > 0 else { return self }
        // Append '=' characters as padding to the end of the string.
        return self + String(repeating: "=", count: requiredPadding)
    }
}
