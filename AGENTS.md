# Nevis Mobile Authentication FIDO2 Example App (iOS)

## Project Overview

A native iOS (Swift 6, SwiftUI) example app that shows how to register and use FIDO2 passkeys against a Nevis Authentication Cloud backend with Apple's Authentication Services framework. It does **not** use the Nevis Mobile Authentication SDK (that SDK is FIDO UAF based); every passkey operation goes through `ASAuthorizationController` and `ASWebAuthenticationSession`. It is meant as a learning resource and a source of integration code for customer apps. It is not a production-ready app.

The repository contains one app target, **`FIDO2 Example`** (sources in `FIDO2/`), with a single screen (`HomeScreenView`).

Flows demonstrated:

- Passkey registration for a username (`POST /api/v1/users/enroll` → passkey creation sheet → `POST /_app/attestation/result`)
  - platform authenticator (`ASAuthorizationPlatformPublicKeyCredentialProvider`, iCloud Keychain or the user's credential manager)
  - security key (`ASAuthorizationSecurityKeyPublicKeyCredentialProvider`) when the authenticator attachment is `cross-platform`
- Passkey authentication (`POST /api/v1/approval` → passkey assertion sheet → `POST /_app/assertion/result`)
  - with a username (the server returns `allowCredentials`)
  - usernameless, with discoverable credentials
  - auto-fill assisted: passkeys are offered in the QuickType bar when the username field is focused (`performAutoFillAssistedRequests()`)
- Browser-based sign-in with `ASWebAuthenticationSession` (registration or authentication on a FIDO2-enabled web page, result returned through a custom URL scheme)
- Token introspection (`POST /api/v1/introspect`) of the JWT returned by every flow, showing whether it is valid, the subject and the issue time
- FIDO2 options selectable in the UI: user verification, authenticator attachment, attestation conveyance and resident key

Paradigm: **Clean Architecture with MVVM**, wired up with Swinject. Async work is modelled with Combine:

- `HomeScreenViewModel` (`ObservableObject`) turns a button tap into a `StartAuthorizationRequest` and runs `StartAuthorizationUseCase`.
- The use case asks `Fido2Repository` for the WebAuthn options from Authentication Cloud and maps them to the domain type `AuthorizationCreationOption`.
- `AuthorizationService` builds the `ASAuthorizationRequest` (`AuthorizationController`), presents the system sheet and publishes the result on its `onComplete` publisher.
- The view model passes the result to `CompleteAuthorizationUseCase` (attestation / assertion), then to `IntrospectUseCase`, and shows the outcome in a message view.

The example covers the native passkey flows against Authentication Cloud only. For the backend side, the REST API and passkey concepts, use the documentation at https://docs.nevis.net/authcloud. Don't infer Authentication Cloud API behavior from memory.

## Platform APIs & Related Resources

How passkeys are implemented:

- **Authentication Services** (system framework, no Nevis SDK): `ASAuthorizationPlatformPublicKeyCredentialProvider`, `ASAuthorizationSecurityKeyPublicKeyCredentialProvider`, `ASAuthorizationController` (modal and auto-fill assisted requests) and `ASWebAuthenticationSession`.
- The relying party ID comes from the server response (`rp.id` on registration, `rpId` on authentication). The app must be associated with that domain through the `webcredentials` Associated Domains entitlement, and the domain must serve an `apple-app-site-association` file that lists the app.
- Other dependencies (Swift Package Manager, `upToNextMajorVersion`): Moya and CombineMoya (HTTP client over Alamofire), Swinject, SwinjectAutoregistration. The resolved versions are in `FIDO2 Example.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

Documentation (https://docs.nevis.net):

- [FIDO2/Passkey example apps](https://docs.nevis.net/authcloud/example-apps/fido2-mobile-example-apps) (setup, demo scenarios, production architecture)
- [Access key](https://docs.nevis.net/authcloud/getting-started/access-key), [Test & Debug page](https://docs.nevis.net/authcloud/getting-started/test-access-app)
- Passkeys: [overview](https://docs.nevis.net/authcloud/authentication-methods/Trusted-key-passkeys), [prerequisites](https://docs.nevis.net/authcloud/authentication-methods/Trusted-key-passkeys/FIDO2-prerequisites), [architecture overview](https://docs.nevis.net/authcloud/authentication-methods/Trusted-key-passkeys/architecture-overview), [browsers and authenticators](https://docs.nevis.net/authcloud/authentication-methods/Trusted-key-passkeys/browsers-and-authenticators), [native app association](https://docs.nevis.net/authcloud/authentication-methods/Trusted-key-passkeys/native-app-association)
- [FIDO2 API use cases](https://docs.nevis.net/authcloud/api-doc/api-use-cases/fido2), indirect communication (recommended for native apps): [register](https://docs.nevis.net/authcloud/api-doc/api-use-cases/fido2/indirect-communication/register-fido2-authenticator), [authenticate](https://docs.nevis.net/authcloud/api-doc/api-use-cases/fido2/indirect-communication/authenticate-with-fido2), [authenticate with autofill UI](https://docs.nevis.net/authcloud/api-doc/api-use-cases/fido2/indirect-communication/authenticate-with-autofill-ui)
- API reference: [registration](https://docs.nevis.net/authcloud/api-doc/api-reference/registration-ref), [attestation](https://docs.nevis.net/authcloud/api-doc/api-reference/attestation-ref), [approval](https://docs.nevis.net/authcloud/api-doc/api-reference/approval-ref), [assertion](https://docs.nevis.net/authcloud/api-doc/api-reference/assertion-ref), [introspect](https://docs.nevis.net/authcloud/api-doc/api-reference/introspect-ref)
- [REST API overview](https://docs.nevis.net/authcloud/api-doc), [configuration options](https://docs.nevis.net/authcloud/api-doc/config-options), [UX guidelines](https://docs.nevis.net/authcloud/api-doc/ux-guidelines)
- [Authentication Cloud documentation](https://docs.nevis.net/authcloud/)

## Prerequisites & Configuration

Backend: a **Nevis Authentication Cloud** instance and an [access key](https://docs.nevis.net/authcloud/getting-started/access-key) for it. For native passkey operations against the default relying party domain (`<instance>.mauth.nevis.cloud`), mobile passkey support must be enabled on the instance, so that its `apple-app-site-association` file lists the app (contact Nevis support). See [native app association](https://docs.nevis.net/authcloud/authentication-methods/Trusted-key-passkeys/native-app-association).

All configuration is **build-time only**. To point the app at your own environment:

1. **Backend settings.** `FIDO2/Resource/Configuration.plist`, decoded into `AppConfiguration` by `ConfigurationLoaderImpl`:
   - `host`: the host name of your instance **without** scheme (for example `myinstance.mauth.nevis.cloud`). The base URL becomes `https://<host>/`.
   - `accessToken`: the access key. It is sent as a bearer token on every request (Moya `AccessTokenPlugin`) and as the `token` query parameter of the web sign-in URL.
   - `pathForAuthorization`: the page opened for the browser-based sign-in, relative to the base URL. The default `fido2-test.html` is the Authentication Cloud Test & Debug page.

   Empty `host` or `accessToken` values are not rejected by the configuration loader; native requests fail later rather than showing a configuration error during loading.
2. **Associated domain.** In `FIDO2/Resource/FIDO2-Example.entitlements`, complete `webcredentials:` to `webcredentials:<host>` (the relying party ID). If the relying party is your own domain, that domain must serve the `apple-app-site-association` file with `<TeamID>.<BundleID>` under `webcredentials`. For a domain that Apple's CDN can't reach during development, append `?mode=developer` to the entry, and remove it before distributing the app.
3. **Web sign-in callback scheme.** In `FIDO2/Resource/FIDO2-Example-Info.plist`, change the first `CFBundleURLSchemes` entry (`fido2.example.app`). `Bundle+UrlScheme` reads the **first** scheme; it is passed to the page as `redirectTo` and used as the `callbackURLScheme` of `ASWebAuthenticationSession`. The page must redirect to `<scheme>://success?token=<jwt>` or `<scheme>://failure?error=<message>` (parsed in `AuthorizationServiceImpl.startWeb`).
4. **Bundle ID and signing.** The bundle ID is `ch.nevis.mobile.authentication.fido2.example`, signing is automatic, and no development team is set. Set your own team; the team must support the Associated Domains capability. If you change the bundle ID or team, the `apple-app-site-association` entry (`<TeamID>.<BundleID>`) must change too, or the system rejects every passkey request for the relying party.
5. **FIDO2 options.** Options left on *Unspecified* are not sent, so the server-side defaults of the instance apply (see [configuration options](https://docs.nevis.net/authcloud/api-doc/config-options)).

## Build & Run Commands

`README.md` has the full setup. Quick reference:

```bash
open "FIDO2 Example.xcodeproj"   # Xcode resolves the SPM packages automatically (File > Packages to retry)
# Run the "FIDO2 Example" scheme on a physical device (passkeys don't work on the simulator).

# Command-line build check (no signing):
xcodebuild -project "FIDO2 Example.xcodeproj" -scheme "FIDO2 Example" \
  -configuration Debug -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build

# Lint (the same check the pull request workflow runs):
xcrun swift-format lint --configuration .swift-format --recursive FIDO2

# Lint the fastlane Ruby files:
bundle install && bundle exec rubocop -c .rubocop.yml
```

Requirements: Xcode 26 or later (Swift 6 language mode). Deployment target: iOS 16.4, iPhone and iPad. There is no "Swift Format" build phase, so formatting is not applied automatically; run `swift-format format --in-place` yourself or fix the lint findings. There are no unit or UI test targets; to verify changes, run the app on a device against an Authentication Cloud instance.

## Architecture

### Source layout

```
FIDO2/
  Application/                   FIDO2App (@main, shows HomeScreenView)
  Presentation/
    Screen/View/                 HomeScreenView (resolves HomeScreenViewModel from the container)
    Screen/ViewModel/            HomeScreenViewModel, sections and buttons of the screen
    Component/                   UsernameTextField (auto-fill), Fido2OptionGroup, Fido2Section, MessageView, LoadingView, Styles
    Model/                       Fido2ViewOption (UI option enums + mapping to the domain), Message, FocusedField
  Domain/
    Authentication/              AuthorizationService(+Impl), AuthorizationController (builds ASAuthorizationRequests), AuthorizationServiceError
    UseCase/                     StartAuthorization, CompleteAuthorization, Introspect (protocol + Impl + preview stub)
    Repository/                  Fido2Repository protocol
    Entity/                      StartAuthorizationRequest/Response, CompleteAuthorizationRequest, AuthorizationCreationOption,
                                 AuthorizationResult, AuthorizationToken, Fido2Options, IntrospectInfo
  Data/
    Repository/                  Fido2RepositoryImpl: builds request DTOs, Base64URL encoding, error mapping to AppError
    DataSource/AuthenticationCloud/  AuthenticationCloud (Moya TargetType: paths, bodies, headers), AuthenticationCloudDataSource(+Impl)
    Model/AuthenticationCloud/   Codable DTOs (Registration, Attestation, Approval, Assertion, Introspect, CredentialCreation/RequestOptions, …)
                                 and their mapping to domain entities
  Common/
    Configuration/               ConfigurationLoader(+Impl), Model/AppConfiguration
    DependencyInjection/         DependencyContainer (DependencyProvider + global `dependencyContainer`)
    Errors/                      AppError
    Extensions/                  Base64URL helpers, Bundle+UrlScheme, MoyaProvider+Extensions (Combine wrapper), UIDevice+DeviceName, …
  Resource/                      Configuration.plist, FIDO2-Example-Info.plist (URL scheme), FIDO2-Example.entitlements
  Documentation.docc/            DocC catalog with the architecture overview
```

### How a passkey ceremony runs

1. `HomeScreenViewModel.startAuthorization(_:)` maps the tapped button to a `StartAuthorizationRequest`. Registration and username-based authentication need a username; the usernameless button sends `username: nil`.
2. `StartAuthorizationUseCaseImpl` calls `Fido2RepositoryImpl.startRegistration` / `startApproval`. The DTOs (`RegistrationResponse.map`, `ApprovalResponse.map`) decode the Base64URL challenge, user ID and credential IDs into an `AuthorizationCreationOption`, wrapped with the server's `statusToken` in a `StartAuthorizationResponse`.
3. `AuthorizationServiceImpl.start(_:isAutoFillAssisted:)` creates an `AuthorizationController` (an `ASAuthorizationController` subclass that keeps the `StartAuthorizationResponse`) and calls `performRequests()`. Registration uses the platform provider, or the security key provider when the attachment is `cross-platform`; authentication uses the platform provider.
4. The `ASAuthorizationControllerDelegate` callback turns the credential into an `AuthorizationResult` and publishes a `CompleteAuthorizationRequest` (with the `statusToken` and, for registration, a device name from `UIDevice.deviceName`) on `onComplete`. User cancellation becomes `AuthorizationServiceError.canceled`.
5. The view model subscribes to `onComplete` and runs `CompleteAuthorizationUseCaseImpl` → `Fido2RepositoryImpl.completeRegistration` / `completeApproval`, which Base64URL-encode the credential data and post it with the `statusToken`. The response is a JWT (`AuthorizationToken`).
6. `IntrospectUseCaseImpl` validates the JWT and the view model shows the result.

Other details:

- **Auto-fill**: the view model starts an auto-fill assisted, usernameless approval when it is created and again after every completed or failed flow (`startAutoFillAssistedAuthorization()`). `UsernameTextField` sets `.textContentType(.username)` only after that request is running. Starting a modal flow cancels the running auto-fill request; that cancellation is ignored, not shown as an error.
- **Web sign-in**: `StartAuthorizationUseCaseImpl` builds `<base URL><pathForAuthorization>?token=…&redirectTo=<scheme>&operation=reg|auth`, calls `AuthorizationService.startWeb` and returns `.webAuthorization`. The callback publishes `.completedWebAuthorization(authorizationToken:)`, which goes straight to introspection.
- **FIDO2 option coupling**: `HomeScreenViewModel.optionValidations()` resets the other options whenever the authenticator attachment changes: for anything other than `cross-platform` (including *Unspecified*) it sets user verification to `preferred`, attestation to `none` and resident key to `required`; for `cross-platform` it sets them to *Unspecified*. Authentication sends only the user verification option.
- **Scopes** (`DependencyContainer`): `ConfigurationLoader` is a singleton; `AuthorizationService` has `.weak` scope, so the view model and `StartAuthorizationUseCaseImpl` share the same instance (the web flow is started by the use case, but its result is published to the view model's subscription); everything else is transient.
- **Errors**: the data layer maps `MoyaError` to `AppError.network` with the server's `message` (`AuthenticationCloudDataSourceImpl.errorMessage(from:)`); DTOs with an error status map to `AppError.request`.
- **Previews**: view models, use cases and services have `static var preview` stubs, so SwiftUI previews don't need a configuration or network.

## Integration Guidance

When moving code into your own app:

| If you want to… | Look at | Notes |
|---|---|---|
| Talk to Authentication Cloud | `AuthenticationCloud`, `AuthenticationCloudDataSourceImpl`, `Fido2RepositoryImpl` | **Don't call the API from the app in production.** Your backend holds the access key and relays the options and results ([indirect communication](https://docs.nevis.net/authcloud/api-doc/api-use-cases/fido2/indirect-communication/register-fido2-authenticator)). Keep the `Fido2Repository` boundary and replace the data source with a client for your backend. |
| Map WebAuthn options to Authentication Services | `RegistrationResponse.map`, `ApprovalResponse.map`, `AuthorizationCreationOption` | Challenge, user ID and credential IDs arrive Base64URL encoded. |
| Create a passkey | `AuthorizationController.createPlatformSpecificRequest` | Sets attestation, user verification and (iOS 17.4+) excluded credentials. |
| Register a security key | `AuthorizationController.createCrossPlatformSpecificRequest` | Also sets credential parameters and resident key. See the gotcha about result handling below. |
| Authenticate with or without a username | `AuthorizationController.createCredentialAuthenticationRequest` | `allowCredentials` restricts the passkeys; without it every discoverable credential for the relying party is offered. |
| Offer passkeys in the keyboard (auto-fill) | `HomeScreenViewModel.startAutoFillAssistedAuthorization()`, `AuthorizationServiceImpl.start(_:isAutoFillAssisted:)`, `UsernameTextField` | [Autofill UI](https://docs.nevis.net/authcloud/api-doc/api-use-cases/fido2/indirect-communication/authenticate-with-autofill-ui). |
| Present the system sheets | `AuthorizationServiceImpl` (delegate, presentation anchor) | Reusable as is; one active controller at a time. |
| Send the credential back | `Fido2RepositoryImpl.completeRegistration` / `completeApproval` | Base64URL-encoded `attestationObject` / `authenticatorData`, `clientDataJSON`, `signature`, `userHandle`, plus the `statusToken`. |
| Sign in through a web page | `AuthorizationServiceImpl.startWeb`, `StartAuthorizationUseCaseImpl.urlForWebAuthorization` | Point it at your own FIDO2 login page; don't put the access key in the URL. |
| Validate the resulting token | `IntrospectUseCaseImpl`, `Fido2RepositoryImpl.introspect` | Introspection needs the access key, so it belongs on your backend. |
| Associate the app with the relying party | `FIDO2-Example.entitlements` | [Native app association](https://docs.nevis.net/authcloud/authentication-methods/Trusted-key-passkeys/native-app-association). |
| Handle errors | `AppError`, `AuthorizationServiceError`, `AuthenticationCloudDataSourceImpl.errorMessage(from:)` | Distinguish user cancellation from failures. |

Demo-only code that should not be copied as is:

- the access key in `Configuration.plist`, sent from the device as a bearer token and as a query parameter of the web sign-in URL (see the production architecture on the [example apps page](https://docs.nevis.net/authcloud/example-apps/fido2-mobile-example-apps))
- calling the attestation, assertion and introspect endpoints directly from the app
- the verbose `NetworkLoggerPlugin`, which logs full requests and responses, including the `Authorization` header, and the `print` of every message
- showing raw technical errors and token claims to users
- the generated device name (`UIDevice.deviceName`) used as the authenticator's friendly name
- the FIDO2 option pickers and the option coupling in `optionValidations()`, which exist to explore server behavior
- the UI components and styling (`Presentation/Component/`)
- the placeholder URL scheme and the Test & Debug page as sign-in page

If something isn't covered here, check https://docs.nevis.net/authcloud (API use cases and API reference) before you write code. Don't guess the API.

## Conventions & Gotchas

- **Physical device only**: the app compiles for the simulator, but the passkey APIs don't work there. Use a device with a passcode, signed in to an Apple ID with iCloud Keychain enabled (or with a third-party credential manager configured).
- **Associated domain must match the relying party**: a missing or wrong `webcredentials` entry, or an `apple-app-site-association` file that doesn't list `<TeamID>.<BundleID>`, makes every passkey request fail. Apple's CDN fetches the file, so changes can take time to reach the device.
- **Security key results are not handled**: `AuthorizationServiceImpl.authorizationController(controller:didCompleteWithAuthorization:)` only maps `ASAuthorizationPlatformPublicKeyCredentialRegistration` and `…Assertion`. A `cross-platform` registration with a security key returns `ASAuthorizationSecurityKeyPublicKeyCredentialRegistration`, which is dropped, so no result is published. Extend the switch if you need security keys.
- **Excluded credentials** are only set on iOS 17.4 and later (`#available` check); on older versions the system may offer to create a second passkey for the same account.
- **One controller at a time**: `start` cancels the running `ASAuthorizationController` (usually the auto-fill request) before it starts a new one, and `startWeb` cancels the running web session. Keep the restart of the auto-fill request after every flow, or the QuickType suggestions disappear.
- **`fatalError` on invalid states**: `StartAuthorizationResponse.statusToken`, `AuthorizationController.createAuthorizationRequest` and `CompleteAuthorizationUseCaseImpl.execute` crash on the web cases. Keep the routing in `HomeScreenViewModel` (web results go straight to introspection) when you change the flows.
- **Base64URL**: the server expects and returns Base64URL (no padding); use the helpers in `Common/Extensions/Data+Base64.swift` and `String+Base64.swift`, not plain Base64.
- **Threading**: use case results are received on the main queue (`.receive(on: DispatchQueue.main)`) before they touch `@Published` state; do the same in new pipelines. The project uses the Swift 6 language mode; Swinject is imported with `@preconcurrency`.
- **Configuration is read lazily and cached** by `ConfigurationLoaderImpl`; `AuthenticationCloud.baseURL` resolves it from the global `dependencyContainer`.
- **Code style**: `swift-format` with `.swift-format` (tab indentation, line length 250, ordered imports). Document types and members with `///` comments; DocC sources are in `FIDO2/Documentation.docc`.
- **Never commit secrets** (the host and access key in `Configuration.plist`, a real team ID, signing certificates, provisioning profiles, fastlane `.env` files) or personal Xcode state (`xcuserdata/`).
