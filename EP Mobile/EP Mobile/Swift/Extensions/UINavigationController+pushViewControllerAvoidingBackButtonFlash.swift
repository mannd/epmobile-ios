//
//  UINavigationController+pushViewControllerAvoidingBackButtonFlash.swift
//  EP Mobile
//
//  Created by David Mann on 10/8/26.
//  Copyright © 2026 EP Studios. All rights reserved.
//
import UIKit

extension UINavigationController {

    /// Works around Back button flashing during animated pushes.
    /// Wrapping the push like this prevents the flashing of the back button.
    /// This flashing appears to be an iOS 27 bug.
    /// See Apple Feedback ID FB25108694 filed 8 Oct 2026.
    /// Remove the wrapper when/if an iOS update solves this problem.
    @objc(pushViewControllerAvoidingBackButtonFlash:animated:)
    func pushViewControllerAvoidingBackButtonFlash(
        _ viewController: UIViewController,
        animated: Bool = true
    ) {
        guard animated, !isNavigationBarHidden else {
            pushViewController(viewController, animated: animated)
            return
        }

        setNavigationBarHidden(true, animated: false)
        pushViewController(viewController, animated: true)
        setNavigationBarHidden(false, animated: false)
    }
}
