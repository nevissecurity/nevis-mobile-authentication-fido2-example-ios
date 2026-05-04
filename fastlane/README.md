fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### main

```sh
[bundle exec] fastlane main
```

Build and distribute the application

#### Options

 * **`version`**: The version of the application.

 * **`build_number`**: The build number of the application.

 * **`host_name`**: The host name of the backend to connect to.

 * **`backend_access_token`**: The token used to access the backend.



### pr

```sh
[bundle exec] fastlane pr
```

Build the application

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
