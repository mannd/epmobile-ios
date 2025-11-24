//
//  HcmAfViewController.swift
//  EP Mobile
//
//  Created by David Mann on 11/23/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmAfViewController: NSObject {

    @MainActor @objc
    static func show(vc: UIViewController) {
        let view = HcmAfView()
        let hostingVC = UIHostingController(rootView: view)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
