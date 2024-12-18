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
      let lines = pemString.components(separatedBy: .newlines)
      var base64String = ""
      var isKeyData = false
      for line in lines {
         if line.contains("-----BEGIN") {
            isKeyData = true
         } else if line.contains("-----END") {
            isKeyData = false
         } else if isKeyData {
            base64String += line
         }
      }
      self.init(base64URLEncoded: base64String)
   }
}
