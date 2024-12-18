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
/**
 * String ext
 */
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
