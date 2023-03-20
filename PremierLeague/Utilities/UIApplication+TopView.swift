//
//  UIApplication+TopView.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 18/03/2023.
//

import Foundation
import UIKit

extension UIApplication {
    public func topViewController() -> UIViewController? {
        let window = UIApplication.shared.keyWindowScene
        return topViewControllerRecursive(controller: window.rootViewController)
    }
    func topViewControllerRecursive(controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewControllerRecursive(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController,
           let selected = tabController.selectedViewController {
            return topViewControllerRecursive(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return topViewControllerRecursive(controller: presented)
        }
        return controller
    }
}

extension UIApplication {
    
    public var keyWindowScene: UIWindow {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow) ?? UIApplication.shared.connectedScenes
        // Keep only Inactive scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundInactive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow) ?? UIWindow()
    }
    
}
