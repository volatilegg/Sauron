# Sauron

<img src="https://user-images.githubusercontent.com/3374348/234277138-b295a372-5e78-42a0-9fa2-9856524c61ce.png" width="100">

An iOS library to check and share network log easier, can be embedded into your iOS app easily

| ![List](https://user-images.githubusercontent.com/3374348/234280767-08772b34-1880-4018-9ec6-69e91624ada8.png) | ![Simulator Screenshot - iPhone 14 Pro - 2023-04-25 at 15 45 30](https://user-images.githubusercontent.com/3374348/234280777-81efb359-6192-4fae-8757-b7fb20a60966.png) | ![Simulator Screenshot - iPhone 14 Pro - 2023-04-25 at 15 45 33](https://user-images.githubusercontent.com/3374348/234280780-6a0b151d-2dfa-49d6-a601-095eec75741b.png) | ![Simulator Screenshot - iPhone 14 Pro - 2023-04-25 at 15 45 35](https://user-images.githubusercontent.com/3374348/234280783-87eb961b-f99e-462f-abe8-290fa0af4b94.png) | ![Simulator Screenshot - iPhone 14 Pro - 2023-04-25 at 15 45 38](https://user-images.githubusercontent.com/3374348/234280787-213c7129-f613-42ed-b095-b9e48408a298.png) |
| --- | --- | --- | --- | --- |

_Insprised by [Reqres](https://github.com/AckeeCZ/Reqres) and [Wormhole](https://github.com/nixzhu/Wormhole)_
## Installation 

### Swift Package Manager

To integrate `Sauron` into your Xcode using Swift Package Manager, add it to the dependencies of `Package.swift`

```
dependencies: [
    .package(url: "https://github.com/volatilegg/Sauron.git", .upToNextMajor(from: "1.0"))
]
```

## Cocoapods

To integrate `Sauron` into your Xcode using Cocoapod, add it to your `Podfile`


```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Sauron', '~> 1.0.0'
end
```

## Usage 

### 1. Network configuration 

#### Default network config

Using `Reqres.defaultSessionConfiguration` as `URLSession.configuration`

```swift
let url = URL(string: "https://pokeapi.co/api/v2/pokemon/108")!
let urlSessionConfig = Reqres.defaultSessionConfiguration(
  additionalHeaders: ["Content-Type":"application/json; charset=UTF-8"],
  additionalHeaders: 40,
  timeoutIntervalForResource: 40,
  requestCachePolicy: .useProtocolCachePolicy
)
let urlSession = URLSession(configuration: config, delegate: nil, delegateQueue: nil)

urlSession.dataTask(
  with: url,
  completionHandler: { (data, response, error) in
      // handling response callback
  }
)
```

#### [Alamofire](https://github.com/Alamofire/Alamofire)/[Moya](https://github.com/Moya/Moya)
Inject `Reqres.defaultSessionConfiguration` into `Alamofire.Session(configuration:{{configuration}})`

```swift
let urlSessionConfig = Reqres.defaultSessionConfiguration(
  additionalHeaders: ["Content-Type":"application/json; charset=UTF-8"],
  additionalHeaders: 40,
  timeoutIntervalForResource: 40,
  requestCachePolicy: .useProtocolCachePolicy
)

// Usage for Alamofire
let sessionManager = Alamofire.Session(configuration: urlSessionConfig)

// Usage for Moya
var provider = MoyaProvider<PokemonAPI>(
  endpointClosure: endpointClosure,
  session: sessionManager,
  plugins: []
)

provider.request(target) { result in
  // handling response callback
}
```

### 2. Configure log mode
_Note_ default mode is `disabled` and should be the mode to use in prodution 

Using this snippet to control the mode 
```swfit
// Display all network information
Sauron.shared.logMode = .enable

// Remove all network information
Sauron.shared.logMode = .disable

// Display network information without request's headers
Sauron.shared.logMode = .disableHeader
```

### 3. Configure log UI

#### SwiftUI 

Open this view `RequestListPresentView()` to see the whole log UI
```swift 
NavigationLink(destination: RequestListPresentView()) {
  Text("Open Log")
}
```

#### UIKit

Open this view `RequestsListViewController` to see the whole log UI

```swift
viewController.show(RequestsListViewController.makeViewController())
```


