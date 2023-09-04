//
//  FacebookAuthService.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FacebookLogin

/// A type that describing the method of auth in the `Facebook`.
public protocol ACFacebookAuthServiceInterface {
    
    /// The view controller to present from.
    var targetView: UIViewController? { get set }
    
    /// Array of permissions.
    var permissions: [ACFacebookPermissionType] { get set }
    
    /// Logs the user in or authorizes additional permissions.
    /// - Warning: You can only perform one login call at a time. Calling a login method before the completion handler is called on a previous login attempt will result in an error.
    /// - Warning: This method will present a UI to the user and thus should be called on the main thread.
    func signIn(handler: @escaping (Result<AccessToken, ACAuthError.FacebookAuthenticationError>) -> Void)
}

// MARK: - Service
/// The object wraps and manages [`FBSDKLoginManager`](https://developers.facebook.com/docs/reference/ios/current/class/FBSDKLoginManager).
public class ACFacebookAuthService: ACFacebookAuthServiceInterface {
    
    // MARK: Properties
    public var permissions: [ACFacebookPermissionType] = []
    public weak var targetView: UIViewController?
    
    /// `FBSDKLoginManager` provides methods for logging the user in and out.
    private lazy var service = LoginManager()

    // MARK: - Initialization
    
    /// Creates `FacebookAuthService` instance.
    /// - Parameters:
    ///   - permissions: Array of permissions
    ///   - targetView: The view controller to present from.
    ///   If nil, the topmost view controller will be automatically determined as best as possible.
    public init(permissions: [ACFacebookPermissionType], targetView: UIViewController?) {
        self.targetView = targetView
        self.permissions = permissions
    }
    
    /// Creates `FacebookAuthService` instace with topmost view controller.
    /// By default, topmost view controller will be automatically determined as best as possible.
    /// - Parameter permissions: Array of permissions
    public convenience init(permissions: [ACFacebookPermissionType]) {
        self.init(permissions: permissions, targetView: .topViewController)
    }
    
    // MARK: - Static methods
    public static func handle(on application: UIApplication, _ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    public static func handleForScene(url: URL) {
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    open class func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Service methods
    public func signIn(handler: @escaping (Result<AccessToken, ACAuthError.FacebookAuthenticationError>) -> Void) {
        self.service.logIn(permissions: permissions.map(\.rawValue), from: targetView, handler: { (_, error) in
            if let error = error {
                handler(.failure(.logInError(error: error)))
                return
            }
            guard let token = AccessToken.current else {
                handler(.failure(.nilWhileUnwrappingAccessToken))
                return
            }
            handler(.success(token))
        })
    }
}
