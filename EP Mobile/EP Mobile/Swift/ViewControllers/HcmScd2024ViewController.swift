//
//  HCMSCD2024ViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/16/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class HcmScd2024ViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let hcmScd2020View = HcmScd2024View()
        let hostingVC = UIHostingController(rootView: hcmScd2020View)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
