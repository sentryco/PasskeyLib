import Foundation

extension Data {
   /**
    * Convert PEM to DER:
    * This initializer takes a PEM encoded string and converts it to DER format.
    * PEM (Privacy-Enhanced Mail) is a base64 encoded format with header and footer lines.
    * DER (Distinguished Encoding Rules) is a binary format.
    *
    * - Parameter pemString: The PEM encoded string.
    */
   init?(pemEncoded pemString: String) {
       // Use a regular expression to extract the base64 encoded string between the PEM headers
       let pattern = "-----BEGIN [^-]+-----\\s*(.*?)\\s*-----END [^-]+-----"
       guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else { return nil }
       // Find the first match in the pemString
       guard let match = regex.firstMatch(in: pemString, range: NSRange(pemString.startIndex..., in: pemString)),
             let base64Range = Range(match.range(at: 1), in: pemString) else { return nil }
       // Remove any whitespace or new lines from the base64 string
       let base64String = pemString[base64Range].components(separatedBy: .whitespacesAndNewlines).joined()
       // Initialize Data with the base64URLEncoded string
       self.init(base64URLEncoded: base64String)
   }
}
