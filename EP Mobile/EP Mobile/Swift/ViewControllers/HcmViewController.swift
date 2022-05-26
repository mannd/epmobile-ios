//
//  HcmViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let hcmView = HcmView()
        let hostingVC = UIHostingController(rootView: hcmView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
