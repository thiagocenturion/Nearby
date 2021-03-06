# iOS Nearby App
> Swift iOS app showcasing nearby places using Google Places API.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Nearby is an app that helps users to find nearby Cafes, Bars and Restaurants. 

This application allows you to see a list of nearby places, selecting one and openning it with Maps, Google Maps and Waze.

Nearby uses user's current location by `CoreLocation` and gets nearby places from [Google Places API](https://developers.google.com/places/web-service/search#PlaceSearchRequests).

[<img src="/Images/header.png">](/Images/header.png)

## Features

- [x] Reactive programming with [RxSwift](https://github.com/ReactiveX/RxSwift).
- [x] MVVM with reactive Coordinator pattern.
- [x] Reactive and componentized API services layer.
- [x] Unit tested modules with [Quick](https://github.com/Quick/Quick) & [Nimble](https://github.com/Quick/Nimble).
- [x] SOLID, Independency Injection, Stubs and Mocks.
- [x] All dependencies using [Swift Package Manager](https://swift.org/package-manager/).
- [x] JSON parses with [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).
- [x] Localization in both English and Portuguese.
- [x] Supports Dark and Light mode.

## Run Sample 
1. Clone this repository.
    ```
    git clone https://github.com/thiagocenturion/Nearby.git
    ```
2. Open `Nearby/Nearby.xcodeproj` in Xcode. 
3. Wait for Swift Package Dependencies to finish downloading.
4. Run.

## Requirements

- iOS 13.0+
- Xcode 12.2

## Screenshots
[<img src="/Images/Screenshots/requestLight.png" align="left" width="250" hspace="0" vspace="10">](/Images/Screenshots/requestLight.png)
[<img src="/Images/Screenshots/placesLight.png" align="center" width="250" hspace="0" vspace="10">](/Images/Screenshots/placesLight.png)
[<img src="/Images/Screenshots/MapsLight.png" align="center" width="250" hspace="0" vspace="10">](/Images/Screenshots/MapsLight.png)
----
[<img src="/Images/Screenshots/requestDark.png" align="left" width="250" hspace="0" vspace="10">](/Images/Screenshots/requestDark.png)
[<img src="/Images/Screenshots/placesDark.png" align="center" width="250" hspace="0" vspace="10">](/Images/Screenshots/placesDark.png)
[<img src="/Images/Screenshots/MapsDark.png" align="center" width="250" hspace="0" vspace="10">](/Images/Screenshots/MapsDark.png)

## Architecture Pattern
The architecture pattern for this application is MVVM with Coordinator. Below, you can view the architecture diagram for this project:
[<img src="/Images//NearbyMVVM.png" align="center" width="100%" hspace="0" vspace="10">](/Images/NearbyMVVM.png)

## Unit Tests
This project tests almost all MVVM-C layers. For that, it was necessary to create Stubs of UIKit native classes, such as `UIViewController`, `UINavigationController`, `CLLocationManager` and `UIApplication` using protocols.

Example:

```swift
protocol UIApplicationType: NSObject {
    func canOpenURL(_ url: URL) -> Bool
}

extension UIApplication: UIApplicationType {}

```

Stub:
```swift
#if UNIT_TEST

import UIKit

final class UIApplicationStub: NSObject, UIApplicationType {
    var canOpenURLCalls: [URL] = []
    var canOpenURLResponse = true
    
    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLCalls.append(url)
        return canOpenURLResponse
    }
}

#endif
```

Usage:
```swift
it("calls canOpenURL correctly") {
                    
    let applicationStub = UIApplicationStub()
    
    expect(applicationStub.canOpenURLCalls.isEmpty) == true
    
    _ = MapsActionSheetViewModel.mock(application: applicationStub)
    
    expect(applicationStub.canOpenURLCalls.count) == 2
    expect(applicationStub.canOpenURLCalls[0]) == URL(string: "https://somestuffurl.com")
    expect(applicationStub.canOpenURLCalls[1]) == URL(string: "https://somesecondstuffurl.com")
}
```

## Project Navigator
Project Navigator for app target and unit test target:

[<img src="/Images/project_navigator_app.png" align="center" width="250" hspace="0" vspace="10">](/Images/project_navigator_app.png)
[<img src="/Images/project_navigator_tests.png" align="center" width="250" hspace="0" vspace="10">](/Images/project_navigator_tests.png)

## Meta

Thiago Centurion – thiagocenturion@me.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/thiagocenturion/github-link](https://github.com/thiagocenturion/)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com