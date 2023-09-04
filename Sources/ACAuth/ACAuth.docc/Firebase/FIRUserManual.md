# User manual

## Two-step 
### Create firebase auth service
Create an ACFIRAuth instance and specify the preferred authorization method
```swift
let appleAuth = ACFIRAuth(provider: .apple(scopes: [.email]))
```
### Сall the login method
```swift
appleAuth.logIn(handler: { result in
    // Process the result
})
```
Result is ``ACFIRAuthResult``.

## Three-step
### Create specification for your remote app.
```swift
let spec = ACFIRRemoteSpecification(source: "your_path")
```

### Create remote performer with your specification.
```swift
let auth = ACFIRAuthRemotePerformer(spec: spec)
```

### Сall the auth method
```swift
auth.auth(with: .apple(scopes: [.email])) { result in
    // Process the result
}
```
Result is ``ACFIRPerformerResult``.

## Topics
### Two-step firebase authorization.
A simple mechanism that provides an easy way to perform authorization by selecting an authorization provider
- ``ACFIRAuth``

Auth protocol for Firebase services.
- ``ACFIRAuthPerformer``

### Three-step firebase authorization with you'r server.
Modified FIRAuth mechanism that requires obtaining rights from an external source
- ``ACFIRAuthRemotePerformer``
- ``ACFIRAuthRemotePerformerProtocol``

### See alos
- ``ACFIRAuthCallback``
