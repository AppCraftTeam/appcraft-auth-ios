# Google authrozation

## Integration guide
Initialize Google service in your app.
1. Import the ACAuth module in your UIApplicationDelegate.
```swift 
import ACAuth
```

2. Configure using the ``GoogleAuthService/handle(url:)`` method of the ``GoogleAuthService`` object in your app delegate's `application(_:didFinishLaunchingWithOptions:)` method:

```swift 
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    GoogleAuthService.handle(url: url)
    return true
}
```

## Topics

### Abstract
- ``GoogleAuthServiceInterface``

### Implementations 
- ``GoogleAuthService``

### Domains
- ``GoogleProfile``
- ``GoogleAuthServiceRestoreSignInState``
- ``GIDDisconnectCallback``
