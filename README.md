# Appeal

<img width="1461" alt="viz-1" src="https://github.com/appeal2/appeal-swift-client/assets/31099945/1ec8b467-56aa-4e1d-b8c0-58b47dea9040">

Appeal is imagined to be a suite of tools that streamline communication between iOS developers and their users. 

Currently, Appeal allows to manage What’s New screen that presents the latest features of your app based on the version of the app.

**Warning**: Appeal is still in the early stages of development. Please, use with caution. Migration guides will be provided when breaking changes are introduced.
 ‏‏‎ ‎
  ‏‏‎ ‎
 ‏‏‎ ‎
  ‏‏‎ ‎
## Installation

### 📦 Swift Package

Add Appeal to your SwiftUI<sup>1</sup> app via Swift Package Manager:
1. In Xcode, go to `File → Add Packages...`
2. Enter `https://github.com/appeal2/appeal-swift-client.git` into the search field.
3. Set Dependency Rule to `Up to Next Major Version` and press Add Package

<sup>1</sup> Appeal doesn’t have an integration with UIKit at the moment.
 ‏‏‎ ‎
  ‏‏‎ ‎
### 💻 Dashboard

Join macOS TestFlight program to access the Dashboard that allows to create accounts, manage apps and releases:
[Join TestFlight](https://testflight.apple.com/join/U0ZIIlhT)
 ‏‏‎ ‎‎ ‎
  ‏‏‎ ‎
 ‏‏‎ ‎
  ‏‏‎ ‎
## Initialization

1. Create a new app in the Dashboard and copy the generated ID. 
2. Import Appeal.
3. Initialize Appeal when the `@main App` is initialized:

```swift
import SwiftUI
import Appeal // ← 2

@main
struct AppealDemo: App {

    init() {
        let config = AppealConfiguration(appId: "<#APP_ID#>")
        Appeal.initialize(with: config)                     // ← 3
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

3. Add `.withWhatsNew()` view modifier to a view that you think is appropriate to be overlayed with What’s New screen. 
   - For example, you may want to attach it to the first view that users see once they are authenticated. This way the updates are presented at the beginning of the core user experience without interrupting the authentication and onboarding flows. 

```swift
struct NavigationManager: View {

    @State var user: User?

    var body: some View {
        if let user {
            MainAppManager()
                .withWhatsNew() // ← Shown to authenticated users
        } else {
            AuthenticationManager()
        }
    }
}
``` 
 ‏‏‎ ‎‎ ‎
  ‏‏‎ ‎
 ‏‏‎ ‎
  ‏‏‎ ‎
## Usage

1. When you create a new Release of the App in the Dashboard app, specify the target version of your app that you want a What’s New screen to be shown in. Version is defined in Xcode `<#APP_TARGET#> → General → Identity → Version`.
   - Currenly, only digits separated by `.` are supported in the app version value. Eg: `1.0` or `0.9.2`.
2. Add Features in the macOS client for the newly created Release.
   - Title, body and the image are required.
3. Build your SwiftUI app with the specified version.
4. By default, What’s New view is shown only once for each new version of the app on a device. You can configure Appeal to show What’s New on every launch when build configuration is set to Debug:
```
let config = AppealConfiguration(appId: "<#APP_ID#>", persistInDebug: true)
```
   - This setting does not affect AppStore builds. Your users will always see only the latest available What’s New screen only once.
