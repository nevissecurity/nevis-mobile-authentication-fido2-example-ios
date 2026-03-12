# Nevis Mobile Authentication FIDO2 Example

iOS example app demonstrating FIDO2 passkey registration and authentication with a Nevis Authentication Cloud backend.

## Overview

This app shows how to integrate [FIDO2](https://fidoalliance.org/fido2/) passkey-based sign-in into an iOS application using Apple's [Authentication Services](https://developer.apple.com/documentation/authenticationservices) framework and a [Nevis Authentication Cloud](https://www.nevis.net/en/authentication-cloud) backend.

![Clean Architecture diagram showing the four layers of the app: Presentation, Domain, Data, and Common.](architecture.svg)

### Features

- **Passkey registration** via `ASAuthorizationController` — creates a FIDO2 passkey bound to the user's iCloud Keychain.
- **Passkey-based authentication** — supports both named-user and usernameless / discoverable-credential flows.
- **Passkey auto-fill assisted sign-in** — surfaces passkeys directly in the iOS QuickType keyboard bar.
- **Web-based OAuth / OIDC authorization** — opens an `ASWebAuthenticationSession` browser for OAuth flows and handles the callback redirect.
- **JWT token introspection** — validates the returned authorization token and displays its claims (subject, issued-at).
- **Configurable FIDO2 options** — user verification, attestation, authenticator attachment, and resident-key preferences are all selectable in the UI.

## Architecture

The app follows [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) with a layered MVVM structure:

| Layer | Responsibility |
|---|---|
| **Presentation** | SwiftUI views driven by `HomeScreenViewModel` (`ObservableObject` + Combine) |
| **Domain** | Use cases, `Fido2Repository` protocol, and `AuthorizationService` wrapping `ASAuthorizationController` |
| **Data** | `Fido2RepositoryImpl` using a Moya-based HTTP client; DTO models and JSON mapping |
| **Common** | `ConfigurationLoader`, `AppError`, utility extensions, Swinject `DependencyContainer` |

## Requirements

- iOS 16.4 or later
- Xcode 16+ / Swift 6.0+
- A running [Nevis Authentication Cloud](https://docs.nevis.net/authcloud/) instance with a valid access key

> Important: Passkey APIs require a **physical device**. They are not available on the iOS Simulator.

## Getting Started

Before building the app, update the three configuration files:

1. **`Configuration.plist`** — set `host` and `accessToken` for your Authentication Cloud instance.
2. **`FIDO2-Example.entitlements`** — update the `webcredentials` associated domain to match your hostname.
3. **`FIDO2-Example-Info.plist`** — set the first `CFBundleURLSchemes` value to the OAuth redirect URL scheme used by your instance.

Then choose **Product › Run** in Xcode (or press ⌘R).

## Dependencies

| Package | Purpose |
|---|---|
| [Moya](https://github.com/Moya/Moya) | Type-safe HTTP networking over Alamofire |
| [CombineMoya](https://github.com/Moya/Moya) | Combine publisher extensions for Moya |
| [Swinject](https://github.com/Swinject/Swinject) | Dependency injection container |
| [SwinjectAutoregistration](https://github.com/Swinject/SwinjectAutoregistration) | Automatic DI registration helpers |

## Topics

### Application

- ``FIDO2App``

### Presentation — Views

- ``HomeScreenView``
- ``Fido2OptionGroup``
- ``Fido2Section``
- ``LoadingView``
- ``MessageView``
- ``UsernameTextField``

### Presentation — View Models

- ``HomeScreenViewModel``
- ``HomeScreenViewModel/Section``
- ``HomeScreenViewModel/SectionButton``

### Presentation — Models

- ``Fido2RequirementViewOption``
- ``Fido2AttestationConveyancePreferenceViewOption``
- ``Fido2AuthenticatorAttachmentViewOption``
- ``FocusedField``
- ``Message``

### Domain — Authorization Service

- ``AuthorizationService``
- ``AuthorizationServiceImpl``
- ``AuthorizationServiceError``
- ``AuthorizationController``

### Domain — Use Cases

- ``StartAuthorizationUseCase``
- ``StartAuthorizationUseCaseImpl``
- ``StartAuthorizationUseCasePreview``
- ``CompleteAuthorizationUseCase``
- ``CompleteAuthorizationUseCaseImpl``
- ``CompleteAuthorizationUseCasePreview``
- ``IntrospectUseCase``
- ``IntrospectUseCaseImpl``
- ``IntrospectUseCasePreview``

### Domain — Repository Protocol

- ``Fido2Repository``

### Domain — Entities

- ``AuthorizationCreationOption``
- ``AuthorizationResult``
- ``AuthorizationToken``
- ``StartAuthorizationRequest``
- ``StartAuthorizationResponse``
- ``CompleteAuthorizationRequest``
- ``IntrospectInfo``
- ``Fido2Options``
- ``Fido2AttestationConveyancePreference``
- ``Fido2AuthenticatorAttachment``
- ``Fido2RequirementOption``

### Data — Repository

- ``Fido2RepositoryImpl``

### Data — Data Source

- ``AuthenticationCloudDataSource``
- ``AuthenticationCloudDataSourceImpl``
- ``AuthenticationCloud``

### Data — DTO Models

- ``RegistrationRequest``
- ``RegistrationResponse``
- ``RegistrationFido2Options``
- ``AttestationRequest``
- ``AttestationResponse``
- ``Attestation``
- ``AssertionRequest``
- ``AssertionResponse``
- ``ApprovalRequest``
- ``ApprovalResponse``
- ``ApprovalData``
- ``ApprovalFido2Options``
- ``IntrospectRequest``
- ``IntrospectResponse``
- ``CredentialCreationOptions``
- ``CredentialRequestOptions``
- ``Credential``
- ``Enrollment``
- ``EnrollmentData``
- ``PubKeyCredParam``
- ``RelyingParty``
- ``User``
- ``AuthenticatorSelection``
- ``AuthenticatorAttachment``
- ``UserVerification``
- ``ResidentKey``
- ``ServerResponse``
- ``ErrorResponse``

### Common — Configuration

- ``ConfigurationLoader``
- ``ConfigurationLoaderImpl``
- ``AppConfiguration``

### Common — Dependency Injection

- ``DependencyProvider``
- ``dependencyContainer``

### Common — Errors

- ``AppError``

### Resource — Assets

- ``ColorResource``
- ``ImageResource``

