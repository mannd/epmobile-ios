//
//  WarfarinClinicViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/14/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class WarfarinClinicController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let warfarinClinicView = WarfarinClinicView()
        let hostingVC = UIHostingController(rootView: warfarinClinicView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
