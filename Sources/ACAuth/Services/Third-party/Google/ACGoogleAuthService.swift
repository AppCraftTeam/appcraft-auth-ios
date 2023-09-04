//
//  ACGoogleAuthService.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import GoogleSignIn

/// A callback block that receives the result of the completion of the operation
///
/// If error value is nil, then consider the operation successful.
public typealias GIDDisconnectCallback = (Error?) -> Void

/// Description of the requirements for the object that will be responsible for performing authorization in `Google`.
///
/// ## Topics
///
/// ### Auth methods
/// - ``signIn(handler:)``
/// - ``signOut()-swift.method``
/// - ``restoreSignIn(handler:)-swift.method``
/// - ``disconnect(handler:)``
/// - ``signOut()-swift.type.method``
/// - ``restoreSignIn(handler:)-swift.type.method``
///
/// ### Getting data
/// - ``getIDToken(handler:)``
/// - ``getCurrentProfile()``
///
public protocol ACGoogleAuthServiceInterface {
    
    /// Marks current user as being in the signed out state.
    func signOut()
    
    /// The `ACGoogleProfile` model representing the current `GIDGoogleUser` or `nil` if there is no signed-in user.
    func getCurrentProfile() -> ACGoogleProfile?
    
    /// Disconnects the current user from the app and revokes previous authentication.
    /// If the operation succeeds, the OAuth 2.0 token is also removed from keychain.
    /// - Parameter handler: A callback block ``GIDDisconnectCallback``.
    ///                    This block will be called asynchronously on the main queue.
    func disconnect(handler: GIDDisconnectCallback?)
    
    /// Attempts to restore a previously authenticated user without interaction.
    func restoreSignIn(handler: @escaping (ACGoogleAuthServiceRestoreSignInState) -> Void)
    
    /// Get a valid access token and a valid ID token, refreshing them first if they have expired or are about to expire.
    ///
    /// - Parameters:
    ///   - handler: A callback block that takes a `IDToken` or an error if the attempt to refresh tokens was unsuccessful.
    ///   The block will be called asynchronously on the main queue.
    func getIDToken(handler: @escaping (Result<String, ACAuthError.GoogleAuthenticationError>) -> Void)
    
    /// Starts an interactive sign-in flow using the provided configuration.
    ///
    /// The callback will be called at the end of this process. Any saved sign-in state will be replaced by the result of this flow.
    /// Note that this method should not be called when the app is starting up, (e.g in `application:didFinishLaunchingWithOptions:`);
    /// instead use the `restorePreviousSignInWithCallback:` method to restore a previous sign-in.
    func signIn(handler: @escaping (Result<ACGoogleProfile, ACAuthError.GoogleAuthenticationError>) -> Void)
   
    /// Attempts to restore a previously authenticated user without interaction.
    static func restoreSignIn(handler: @escaping (ACGoogleAuthServiceRestoreSignInState) -> Void)
   
    /// Marks current user as being in the signed out state.
    static func signOut()
}

// MARK: - Service
/// An object that implements the authorization methods described in ``ACGoogleAuthServiceInterface``.
///
/// The service manages the `GIDSignIn` object in order to create the simplest possible method for authorization.
///
/// - Warning: Before working with Google authorization, read the official documentation,
/// section [Get started with Google Sign-In for iOS and macOS](https://developers.google.com/identity/sign-in/ios/start-integrating?hl=en)
open class ACGoogleAuthService: ACGoogleAuthServiceInterface {
    
    // MARK: Properties
    private let service: GIDSignIn = .sharedInstance
    
    /// The object represents the client's configuration
    public private(set) var configuration: GIDConfiguration
   
    /// The view controller to present from.
    public weak var targetView: UIViewController?

    // MARK: - Initialization
    /// Creates `GoogleAuthService` instance.
    /// - Parameters:
    ///   - configuration: The object represents the client's configuration
    ///   - targetView: The view controller to present from.
    public init(configuration: GIDConfiguration, targetView: UIViewController?) {
        self.targetView = targetView
        self.configuration = configuration
    }
    
    /// Creates `GoogleAuthService` instance.
    ///
    /// By default, topmost view controller will be automatically determined as best as possible.
    /// - Parameter configuration: The object represents the client's configuration
    public convenience init(configuration: GIDConfiguration) {
        self.init(configuration: configuration, targetView: .topViewController)
    }
    
    // MARK: - Static methods
    /// This method should be called from your `UIApplicationDelegate`'s `application:openURL:options:` method.
    public static func handle(url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    public static func restoreSignIn(handler: @escaping (ACGoogleAuthServiceRestoreSignInState) -> Void)  {
        GIDSignIn.sharedInstance.restorePreviousSignIn(completion: { (user, error) in
            if error != nil || user == nil {
                 handler(.signOut(error: error))
            } else {
                if let user = user {
                    handler(.signIn(profile: ACGoogleProfile(user: user)))
                } else {
                    handler(.signOut(error: nil))
                }
            }
        })
    }
    
    public static func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Service methods
    
    public func signOut() {
        Self.signOut()
    }
    
    public func restoreSignIn(handler: @escaping (ACGoogleAuthServiceRestoreSignInState) -> Void)  {
        Self.restoreSignIn(handler: handler)
    }

    public func signIn(handler: @escaping (Result<ACGoogleProfile, ACAuthError.GoogleAuthenticationError>) -> Void) {
        guard let targetView = targetView else {
            handler(.failure(.nilWhileUnwrappingTargetView))
            return
        }
        self.service.configuration = configuration
        self.service.signIn(withPresenting: targetView, completion: { (result, error) in
            if let user = result?.user {
                handler(.success(ACGoogleProfile(user: user)))
            } else {
                handler(.failure(.signInError(error: error)))
            }
        })
    }
    
    public func getCurrentProfile() -> ACGoogleProfile? {
        guard let user = service.currentUser else {
            return nil
        }
        return ACGoogleProfile(user: user)
    }
    
    public func getIDToken(handler: @escaping (Result<String, ACAuthError.GoogleAuthenticationError>) -> Void) {
        guard let profile = service.currentUser else {
            handler(.failure(.fetchIDTokenError(error: nil)))
            return
        }
        profile.refreshTokensIfNeeded { user, error in
            if let token = user?.idToken?.tokenString {
                handler(.success(token))
            } else {
                handler(.failure(.fetchIDTokenError(error: error)))
            }
        }
    }
    
    public func disconnect(handler: GIDDisconnectCallback?) {
        self.service.disconnect(completion: handler)
    }
}
