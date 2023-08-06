# Appeal

<img width="1373" alt="viz-1" src="https://github.com/andgordio/UXMClient/assets/31099945/a18edcf2-0182-4bc6-9a19-5a66259d0cac">

Appeal is imagined to be a suite of tools that streamline communication between iOS developers and their users. In its current state, Appeal is a single integration of What’s New screen that allows developers to inform users about updates in the latest version of the app.

### Warning

Appeal is still in the early stages of development. Please, use with caution. Migration guides will be provided when breaking changes are introduced.
 ‏‏‎ ‎
  ‏‏‎ ‎
## Installation

### 📱 Appeal Swift Client

Appeal is available via Swift Package Manager:
1. In Xcode, go to File → Add Packages...
2. Enter `https://github.com/appeal2/appeal-swift-client.git` into the search field.
3. Set Dependency Rule to Up to Next Major Version and press Add Package

`Please note: the Client doesn’t have UIKit integration at the moment.`
 ‏‏‎ ‎
  ‏‏‎ ‎
### 💻 macOS Dashboard

[Get macOS app via TestFlight](https://apps.apple.com/us/app/...) to create an account, manage apps and releases.\
 ‏‏‎ ‎
  ‏‏‎ ‎
### Initialization

1. Create an app in macOS Dashboard and copy the App ID.
   - App ID is shown when the app is created. You can also access it by right-clicking on the app name in the sidebar and chosing App Id from the menu. 
2. Import Appeal and initialize it when your SwiftUI app is initialized:

```swift
import SwiftUI
import Appeal

@main
struct AppealDemo: App {

    init() {
        let config = AppealConfiguration(appId: "<#APP_ID#>")
        Appeal.initialize(with: config)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

3. Add `.withWhatsNew()` view modifier to a view that you think is appropriate to be overlayed with What’s New screen. For example, you may want to attach it to the first view that users see once they are authenticated. This way the updates are presented at the beginning of the core user experience without interrupting the authentication and onboarding flows. 

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
 ‏‏‎ ‎
 ‏‏‎ ‎
## Usage

1. When you create a new Release of the App in the macOS client specify the target version of your app that you want a What’s New screen to be shown in. Version is defined in Xcode `<#APP_TARGET#> → General → Identity → Version` 
2. Add Features in the macOS client for the newly created Release.
3. Build your app with the specified version.
4. By default, What’s New view is shown only once for each new version of the app on a device. You can configure Appeal Client to show What’s New on every launch when build configuration is set to Debug:
```
let config = AppealConfiguration(appId: "<#APP_ID#>", persistInDebug: true)
```
   - This setting does not affect AppStore builds. Your users will always see only the latest available What’s New screen only once.
