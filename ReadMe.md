![Nevis Logo](https://www.nevis.net/hubfs/Nevis/images/logotype.svg)

# Nevis Mobile Authentication FIDO2 Example App

[![Main Branch Commit](https://github.com/nevissecurity/nevis-mobile-authentication-poc-ios-fido2/actions/workflows/main.yml/badge.svg)](https://github.com/nevissecurity/nevis-mobile-authentication-poc-ios-fido2/actions/workflows/main.yml)
[![Verify Pull Request](https://github.com/nevissecurity/nevis-mobile-authentication-poc-ios-fido2/actions/workflows/pr.yml/badge.svg)](https://github.com/nevissecurity/nevis-mobile-authentication-poc-ios-fido2/actions/workflows/pr.yml)

This repository contains the example app demonstrating how to use Passkeys for registration and authentication with a [FIDO2](https://fidoalliance.org/fido2/) capable server such as a [Nevis Authentication Cloud](https://www.nevis.net/en/authentication-cloud) instance.

The application can initiate registration and authentication requests to the configured server and ask the user for Passkey creation/usage to complete the processes/operations.

## Getting Started

Before you start compiling and using the example application please ensure you have the following ready:

- An [Authentication Cloud](https://docs.nevis.net/authcloud/) instance provided by Nevis.
- An [access key](https://docs.nevis.net/authcloud/getting-started/access-key) to use with the Authentication Cloud.

Your development setup has to meet the following prerequisites:

* iOS 16 or later
* Xcode 16.3+, including Swift 6.1.0+

### Initialization

Dependencies in this project are provided via [Swift Package Manager](https://developer.apple.com/documentation/xcode/swift-packages).

### Configuration

Before being able to use the example app with your Authentication Cloud instance, you'll need to update the configuration file with the right information.

Edit the [Configuration.plist](FIDO2/Resource/Configuration.plist) file and replace 
- The host name information with your Authentication Cloud instance.
- The access token with your access key.

Edit the [FIDO2-Example.entitlements](FIDO2/Resource/FIDO2-Example.entitlements) file and update the associated domains for web credentials with your Authentication Cloud instance.

### Build & run

Now you're ready to build and run the example app by choosing Product > Run from Xcode's menu or by clicking the Run button in your project’s toolbar.

> [!NOTE]
> Running the app on an iOS device requires codesign setup.


© 2025 made with ❤ by Nevis
