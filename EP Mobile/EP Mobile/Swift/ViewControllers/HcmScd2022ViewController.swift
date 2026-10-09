//
//  HCMSCD2022ViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/16/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmScd2022ViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let hcmScd2022View = HcmScd2022View()
        let hostingVC = UIHostingController(rootView: hcmScd2022View)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
