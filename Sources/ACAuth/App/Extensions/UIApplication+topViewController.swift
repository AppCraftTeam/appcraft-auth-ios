//
//  UIApplication+topViewController.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import UIKit

extension UIApplication {
    /// Returns the top view controller in the application.
    /// - Returns: Top view controller or nil.
    class func topViewController(
        base: UIViewController? = UIApplication.shared.mainWindow?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return self.topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return self.topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return self.topViewController(base: presented)
        }
        
        return base
    }
    
    static func topViewController() -> UIViewController? {
        topViewController(base: UIApplication.shared.mainWindow?.rootViewController)
    }
    
    var mainWindow: UIWindow? {
        guard #available(iOS 15, *) else {
            return windows.first(where: { $0.isKeyWindow })
        }
        return self.connectedScenes
            .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

extension UIViewController {
    public static var topViewController: UIViewController? {
        UIApplication.topViewController()
    }
}

