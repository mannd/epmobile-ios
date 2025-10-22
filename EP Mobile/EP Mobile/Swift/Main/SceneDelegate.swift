//
//  SceneDelegate.swift
//  EP Mobile
//
//  Created by David Mann on 10/21/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // If Main Interface is set, do not create a new window or set rootViewController.
        // Just guard-cast and return.
        NSLog("Scene willConnectTo called")
        guard scene is UIWindowScene else { return }
    }
}
