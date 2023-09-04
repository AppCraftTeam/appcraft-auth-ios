# Getting Started with ACAuth


## Overview
ACAuth is a library that provides authorization methods in the most popular services, such as Google, Apple, etc. 
You will find a friendly interface, ease of use and the necessary flexibility when it is needed.

## Integration guide

### Swift Package Manager

**For xcode project:**

Go to `File` -> `Add Packages` and enter repository URL:
```
https://github.com/AppCraftTeam/appcraft-auth-ios.git
```

You can also navigate to your target’s General pane, and in the “Frameworks, Libraries, and Embedded Content” section, click the + button, select Add Other, and choose Add Package Dependency.

- Note: If you have any problems, then refer to the [official documentation](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).

**For other lib:**

To include ACAuth into a SPM package, add it to the dependencies attribute defined in your Package.swift file. 
You can select the version using the version parameter. 
For example:
```swift
dependencies: [
  .package(url: "https://github.com/AppCraftTeam/appcraft-auth-ios.git", from: <version>)
]
```

## Configure authorization 
To set up the work environment with a specific authorization type, refer to the documentation for the selected authorization method.
