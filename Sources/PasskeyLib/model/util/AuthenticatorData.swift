/// Generates authenticator data for a given relying party.
///
/// This function constructs a byte sequence that represents authenticator data used in
/// cryptographic operations. It includes the SHA-256 hash of the relying party identifier,
/// user presence and verification flags, and a signature counter.
///
/// - Parameter relyingParty: A string identifier for the relying party, typically a domain name.
/// - Returns: A `Data` object representing the authenticator data.
internal func authenticatorData(relyingParty: String) -> Data {
    // Compute SHA-256 hash of the relying party identifier.
    let rpIDHash = relyingParty.utf8data.sha256.asData

    // Define flags indicating user presence, verification, and other attributes.
    let flags = AuthDataFlags.uv | AuthDataFlags.up | AuthDataFlags.be | AuthDataFlags.bs

    // Initialize a counter to zero, represented as 4 bytes of zero data.
    let counter = Data(repeating: 0, count: 4)

    // Combine all components to form the authenticator data.
    var result = Data()
    result.append(rpIDHash)
    result.append(flags)
    result.append(counter)
    assert(result.count == 37)  // Ensure the data structure is correctly formed.

    return result
}