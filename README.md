<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://www.nevis.net/hubfs/Nevis%202023%20theme/Icons/negativ.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://www.nevis.net/hubfs/Nevis%202023%20theme/Icons/positiv.svg">
  <img alt="Fallback image description" src="https://www.nevis.net/hubfs/Nevis/images/logotype.svg">
</picture>

# Nevis Mobile Authentication FIDO2 Example App

[![Main Branch Commit](https://github.com/nevissecurity/nevis-mobile-authentication-fido2-example-ios/actions/workflows/main.yml/badge.svg)](https://github.com/nevissecurity/nevis-mobile-authentication-fido2-example-ios/actions/workflows/main.yml)
[![Verify Pull Request](https://github.com/nevissecurity/nevis-mobile-authentication-fido2-example-ios/actions/workflows/pr.yml/badge.svg)](https://github.com/nevissecurity/nevis-mobile-authentication-fido2-example-ios/actions/workflows/pr.yml)

iOS example app demonstrating [FIDO2](https://fidoalliance.org/fido2/) passkey registration and authentication with a [Nevis Authentication Cloud](https://www.nevis.net/en/authentication-cloud) backend using Apple's [Authentication Services](https://developer.apple.com/documentation/authenticationservices) framework.

## Features

- **Passkey registration** via [`ASAuthorizationController`](https://developer.apple.com/documentation/authenticationservices/asauthorizationcontroller) — creates a [FIDO2 passkey](https://passkeys.dev) bound to the user's iCloud Keychain
- **Passkey-based authentication** — supports both named-user and usernameless/[discoverable credential](https://www.w3.org/TR/webauthn/#client-side-discoverable-credential) flows
- **Passkey auto-fill assisted sign-in** — integrates with the iOS QuickType bar to surface passkeys directly in the keyboard
- **Web-based OAuth/OIDC authorization** — opens an [`ASWebAuthenticationSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) browser for OAuth flows and handles the callback redirect
- **JWT token introspection** — validates the returned authorization token and displays its claims (subject, issued-at)
- **Configurable FIDO2 options** — user verification, attestation, authenticator attachment, and resident key preferences are all selectable in the UI

## FIDO2 Options

The app exposes four option groups that are sent to the server as part of the registration or authentication request. See the [WebAuthn specification](https://www.w3.org/TR/webauthn/) for the full definition of each option.

### User Verification
Controls whether the authenticator must verify the user (e.g. Face ID, Touch ID, PIN). See [`userVerification`](https://www.w3.org/TR/webauthn/#dom-publickeycredentialrequestoptions-userverification).

| Value | Meaning |
|---|---|
| `required` | User verification is mandatory |
| `preferred` | User verification is preferred but not mandatory |
| `discouraged` | User verification should not be performed |

### Attestation
Controls whether the server requests cryptographic proof of the authenticator's provenance. See [attestation conveyance preference](https://www.w3.org/TR/webauthn/#enum-attestation-convey).

| Value | Meaning |
|---|---|
| `none` | No attestation required |
| `indirect` | Anonymised attestation statement requested |
| `direct` | Full attestation statement requested |

### Authenticator Attachment
Restricts which class of authenticator may be used. See [`authenticatorAttachment`](https://www.w3.org/TR/webauthn/#enum-attachment).

| Value | Meaning |
|---|---|
| `platform` | Built-in authenticator (Face ID, Touch ID) |
| `cross-platform` | Roaming authenticator (security key, another device) |

### Resident Key
Controls whether the credential is stored on the authenticator (discoverable credential), enabling usernameless authentication. See [`residentKey`](https://www.w3.org/TR/webauthn/#dom-authenticatorselectioncriteria-residentkey).

| Value | Meaning |
|---|---|
| `required` | A resident/discoverable credential must be created |
| `preferred` | A resident credential is preferred |
| `discouraged` | A non-resident credential is preferred |

## Getting Started

Before you start compiling and using the example application please ensure you have the following ready:

- A running [Nevis Authentication Cloud](https://docs.nevis.net/authcloud/) instance.
- An [access key](https://docs.nevis.net/authcloud/getting-started/access-key) for your Authentication Cloud instance.

Your development setup has to meet the following prerequisites:

* iOS 16.4 or later
* Xcode 16+, including Swift 6.0+

## Passkeys Support

Passkeys on iOS are backed by [iCloud Keychain](https://support.apple.com/guide/security/icloud-keychain-sec3e341e75d/web) and require the device to be signed in to an Apple ID. Passkeys are available from **iOS 16** onwards via the [Authentication Services](https://developer.apple.com/documentation/authenticationservices) framework. See Apple's [Supporting Passkeys](https://developer.apple.com/documentation/authenticationservices/public-private_key_authentication/supporting_passkeys) guide for a full overview.

## Initialization

Dependencies in this project are provided via [Swift Package Manager](https://developer.apple.com/documentation/xcode/swift-packages).

| Dependency | Purpose |
|---|---|
| [Moya](https://github.com/Moya/Moya) | Type-safe HTTP networking abstraction over Alamofire |
| [CombineMoya](https://github.com/Moya/Moya) | Combine publisher extensions for Moya requests |
| [Swinject](https://github.com/Swinject/Swinject) | Dependency injection container |
| [SwinjectAutoregistration](https://github.com/Swinject/SwinjectAutoregistration) | Automatic dependency registration helpers for Swinject |

## Configuration

Before being able to use the example app with your Authentication Cloud instance, you'll need to update the configuration files with the right information.

Edit the [Configuration.plist](FIDO2/Resource/Configuration.plist) file and replace:
- The host name with your Authentication Cloud instance hostname.
- The access token with your access key.

Edit the [FIDO2-Example.entitlements](FIDO2/Resource/FIDO2-Example.entitlements) file and update the `webcredentials` associated domain with your Authentication Cloud instance hostname.

Edit the [FIDO2-Example-Info.plist](FIDO2/Resource/FIDO2-Example-Info.plist) file and set the first value in the `CFBundleURLSchemes` array to the URL scheme used by your Authentication Cloud instance for redirecting back to the app after webview authorization.

## Build & Run

Now you're ready to build and run the example app by choosing **Product > Run** from Xcode's menu or by clicking the **Run** button in your project's toolbar.

> [!NOTE]
> Running the app on an iOS device requires codesign setup. Passkey APIs are not available on the iOS Simulator.

## Architecture

The app follows [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) with a layered MVVM structure:

```
Presentation (SwiftUI + MVVM)
      ↓
Domain (Use Cases, Repository protocol, AuthorizationService)
      ↓
Data (Moya HTTP client, Repository implementation, DTO models)
      ↓
Common (Configuration, Error handling, Extensions, DI)
```

- **Presentation** — SwiftUI views driven by `HomeScreenViewModel` (`ObservableObject` with `@Published` properties and Combine).
- **Domain** — Use cases (`StartAuthorizationUseCase`, `CompleteAuthorizationUseCase`, `IntrospectUseCase`), the `Fido2Repository` protocol, and `AuthorizationService` which wraps [`ASAuthorizationController`](https://developer.apple.com/documentation/authenticationservices/asauthorizationcontroller) and [`ASWebAuthenticationSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession).
- **Data** — `Fido2RepositoryImpl` implements the repository protocol by calling `AuthenticationCloudDataSourceImpl` (Moya-based HTTP client). DTO models handle JSON serialization and mapping to domain entities.
- **Common** — `AppConfiguration`/`ConfigurationLoader`, unified `AppError` type, utility extensions, and a [Swinject](https://github.com/Swinject/Swinject) `DependencyContainer`.

## Registration Flow

1. User enters a username and taps **Register**
2. `HomeScreenViewModel.startAuthorization(.registration)` calls `StartAuthorizationUseCaseImpl`
3. `Fido2RepositoryImpl.startRegistration()` POSTs to `/api/v1/users/enroll` and receives a [WebAuthn `CredentialCreationOptions`](https://www.w3.org/TR/webauthn/#dictdef-publickeycredentialcreationoptions) challenge
4. The response is mapped to `AuthorizationCreationOption` and passed to `AuthorizationServiceImpl`
5. `AuthorizationServiceImpl` creates an [`ASAuthorizationController`](https://developer.apple.com/documentation/authenticationservices/asauthorizationcontroller) with a platform credential registration request
6. iOS presents the system passkey creation sheet; the user consents with Face ID / Touch ID
7. `AuthorizationServiceImpl` receives the `ASAuthorizationPlatformPublicKeyCredentialRegistration` result
8. `HomeScreenViewModel.completeAuthorization()` calls `CompleteAuthorizationUseCaseImpl`
9. `Fido2RepositoryImpl.completeRegistration()` POSTs the Base64URL-encoded [attestation object](https://www.w3.org/TR/webauthn/#sctn-attestation) to `/_app/attestation/result`
10. The returned JWT is introspected and the result is displayed

## Authentication Flow

1. User optionally enters a username and taps **Authenticate** (leave blank for usernameless)
2. `StartAuthorizationUseCaseImpl` calls `Fido2RepositoryImpl.startApproval()` (POST `/api/v1/approval`)
3. The server returns a [WebAuthn `CredentialRequestOptions`](https://www.w3.org/TR/webauthn/#dictdef-publickeycredentialrequestoptions) challenge, mapped to `AuthorizationCreationOption`
4. `AuthorizationServiceImpl` presents the passkey assertion sheet via [`ASAuthorizationController`](https://developer.apple.com/documentation/authenticationservices/asauthorizationcontroller)
5. The user selects a passkey and authenticates with Face ID / Touch ID
6. `AuthorizationServiceImpl` receives `ASAuthorizationPlatformPublicKeyCredentialAssertion` and publishes the result
7. `Fido2RepositoryImpl.completeApproval()` POSTs the [assertion response](https://www.w3.org/TR/webauthn/#sctn-verifying-assertion) to `/_app/assertion/result`
8. The returned JWT is introspected and the result is displayed

## Troubleshooting

| Symptom | Likely Cause & Fix |
|---|---|
| App crashes on launch | `Configuration.plist` host or access token is not set — fill in both values |
| Passkey creation fails | Ensure [iCloud Keychain](https://support.apple.com/guide/security/icloud-keychain-sec3e341e75d/web) is enabled and the device is signed in to an Apple ID |
| "No credentials available" during authentication | Register first using the same Apple ID on the same or a linked device |
| Associated domain / WebAuthn RP ID mismatch | Update the `webcredentials` entitlement in `FIDO2-Example.entitlements` with your correct hostname |
| Build or passkey APIs fail on Simulator | [Passkey APIs require a physical device](https://developer.apple.com/documentation/authenticationservices/public-private_key_authentication/supporting_passkeys) — use a real device |

---

© 2026 made with ❤ by Nevis
