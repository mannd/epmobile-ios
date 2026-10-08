//
//  BackButtonWorkaroundSegue.swift
//  EP Mobile
//
//  Created by David Mann on 10/8/26.
//  Copyright © 2026 EP Studios. All rights reserved.
//

import UIKit

final class BackButtonWorkaroundSegue: UIStoryboardSegue {
    override func perform() {
        guard let navigationController = source.navigationController else {
            assertionFailure("This segue requires a navigation controller.")
            return
        }

        navigationController.pushViewControllerAvoidingBackButtonFlash(
            destination,
            animated: true
        )
    }
}
