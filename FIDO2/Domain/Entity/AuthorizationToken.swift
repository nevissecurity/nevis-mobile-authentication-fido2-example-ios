//
// FIDO2 Example
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

/// A JWT string returned by the Authentication Cloud after a successful
/// registration or authentication ceremony.
///
/// Pass this token to ``IntrospectUseCase`` to validate it and retrieve claims.
typealias AuthorizationToken = String
