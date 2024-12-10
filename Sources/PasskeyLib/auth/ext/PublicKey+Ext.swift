import CryptoKit

extension P256.Signing.PublicKey {
    /** Verifies a signature for given data using this public key.
     * - Parameters:
     *   - signature: The signature to verify.
     *   - data: The data that was supposedly signed.
     * - Returns: A Boolean value indicating whether the signature is valid.
     */
    func isValidSignature(_ signature: Data, for data: Data) -> Bool {
        do {
            // Convert the signature from Data to a CryptoKit signature type
            let cryptoSignature = try P256.Signing.ECDSASignature(derRepresentation: signature)
            // Use CryptoKit's built-in verification method
            return self.isValidSignature(cryptoSignature, for: data)
        } catch {
            print("Failed to verify signature: \(error)")
            return false
        }
    }
}
