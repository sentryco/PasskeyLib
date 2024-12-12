import Foundation

extension Data {
   // Convert PEM to DER:
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
