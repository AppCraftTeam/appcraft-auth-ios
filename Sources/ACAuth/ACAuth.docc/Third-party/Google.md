# Google authrozation

## Integration guide
Initialize Google service in your app.
1. Import the ACAuth module in your UIApplicationDelegate.
```swift 
import ACAuth
```

2. Configure using the ``ACGoogleAuthService/handle(url:)`` method of the ``ACGoogleAuthService`` object in your app delegate's `application(_:didFinishLaunchingWithOptions:)` method:

```swift 
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    ACGoogleAuthService.handle(url: url)
    return true
}
```

## Topics

### Abstract
- ``ACGoogleAuthServiceInterface``

### Implementations 
- ``ACGoogleAuthService``

### Domains
- ``ACGoogleProfile``
- ``ACGoogleAuthServiceRestoreSignInState``
- ``GIDDisconnectCallback``
