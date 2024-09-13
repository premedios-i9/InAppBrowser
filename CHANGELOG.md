# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [Unreleased]

### [4.0.0-OS14] - 2023-08-31
### Fixes
- Do not lose callbackContext when opening a SYSTEM url (https://outsystemsrd.atlassian.net/browse/RMET-2802).
- Fix beforeLoad not being called in some requests (https://outsystemsrd.atlassian.net/browse/RMET-2802).
- Fix memory leak with webview (https://outsystemsrd.atlassian.net/browse/RMET-2802).

### [4.0.0-OS13] - 2023-01-18
### Fix
- Android - InAppBrowser not opening when no options are passed - check for next element before trying to obtain. (https://outsystemsrd.atlassian.net/browse/RMET-2119)

### [4.0.0-OS12] - 2022-06-29
### Fix
- Removed hook that adds swift support and added the plugin as dependecy. (https://outsystemsrd.atlassian.net/browse/RMET-1680)

### [4.0.0-OS11] - 2022-05-23
### Fix
- Added permission request for camera and microphone on Android's ChromeWebClient.

### [4.0.0-OS9] - 2021-12-07
### Fix
- Removed Swift extensions to compile projects names with non-ascii characters.

### [4.0.0-OS8] - 2021-11-04
### Fix
- New plugin release to include metadata tag in Extensibility Configurations in the OS wrapper

### [4.0.0-OS7] - 2021-09-16
### Fix
- Removed code that is only used in iOS 11 and older [RPM-1453](https://outsystemsrd.atlassian.net/browse/RPM-1453)

### [4.0.0-OS6] - 2021-06-30
- On iOS page scrolling back to top after clicking Done in form input field [RMET-753](https://outsystemsrd.atlassian.net/browse/RMET-753)

## [4.0.0-OS5] - 2021-05-14
### Fix
- Close button has an incorrect name after setting button caption as "Empty" (Android) [RMET-331](https://outsystemsrd.atlassian.net/browse/RMET-331)

## [3.1.0-OS3] - 2020-01-08
### Changes
- Add compile-time decision for disabling UIWebView [RNMT-3569](https://outsystemsrd.atlassian.net/browse/RNMT-3569)

### Fixes
- Background color now takes dark mode into account [RNMT-3631](https://outsystemsrd.atlassian.net/browse/RNMT-3631)
- Improvements to view positioning depending on which options are used [RNMT-3631](https://outsystemsrd.atlassian.net/browse/RNMT-3631)
- Fixes related to the usage of safe area insets [RNMT-3631](https://outsystemsrd.atlassian.net/browse/RNMT-3631)

## [3.1.0-OS2] - 2019-10-04
### Fixes
- Now opens in iOS 13 when using WKWebView [RNMT-3324](https://outsystemsrd.atlassian.net/browse/RNMT-3324)
- Options unmarshalling is now based on property type instead of content type [RNMT-3309](https://outsystemsrd.atlassian.net/browse/RNMT-3309)

## [3.1.0-OS1] - 2019-09-17
### Fixes
- User-Agent is no longer incorrect in the first usage of open [RNMT-3299](https://outsystemsrd.atlassian.net/browse/RNMT-3299)
- Keyboard no longer breaks UI due to scroll view not being repositioned [RNMT-3293](https://outsystemsrd.atlassian.net/browse/RNMT-3293)

## [3.1.0-OS] - 2019-09-10
### Changes
- Merge upstream (3.1.0) into OutSystems branch [RNMT-3220](https://outsystemsrd.atlassian.net/browse/RNMT-3220)

### Additions
- Use WKWebView engine when available [RNMT-3220](https://outsystemsrd.atlassian.net/browse/RNMT-3220)

### Fixes
- Top safe area inset is now being correctly used when using WKWebView [RNMT-3220](https://outsystemsrd.atlassian.net/browse/RNMT-3220)

## [3.0.0-OS1] - 2019-06-04
### Additions
- Add a hook to conditionally set cleartextTrafficPermitted to true [RNMT-2921](https://outsystemsrd.atlassian.net/browse/RNMT-2921)

## [3.0.0-os] - 2018-12-04
### Changes
- Merge upstream (3.0.0) into OutSystems branch

[Unreleased]: https://github.com/OutSystems/cordova-plugin-inappbrowser/compare/3.1.0-OS3...HEAD
[3.1.0-OS3]: https://github.com/OutSystems/cordova-plugin-inappbrowser/compare/3.1.0-OS2...3.1.0-OS3
[3.1.0-OS2]: https://github.com/OutSystems/cordova-plugin-inappbrowser/compare/3.1.0-OS1...3.1.0-OS2
[3.1.0-OS1]: https://github.com/OutSystems/cordova-plugin-inappbrowser/compare/3.1.0-OS...3.1.0-OS1
[3.1.0-OS]: https://github.com/OutSystems/cordova-plugin-inappbrowser/compare/3.0.0-OS1...3.1.0-OS
[3.0.0-OS1]: https://github.com/OutSystems/cordova-plugin-inappbrowser/compare/3.0.0-os...3.0.0-OS1
[3.0.0-os]: https://github.com/OutSystems/cordova-plugin-inappbrowser/compare/1.7.0-os...3.0.0-os
