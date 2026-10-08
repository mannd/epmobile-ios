//
//  FrailtyViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/18/23.
//  Copyright © 2023 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class FrailtyViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let frailtyView = FrailtyView()
        let hostingVC = UIHostingController(rootView: frailtyView)
        vc.navigationController?.pushViewControllerAvoidingBackButtonFlash(hostingVC, animated: true)
    }
}
