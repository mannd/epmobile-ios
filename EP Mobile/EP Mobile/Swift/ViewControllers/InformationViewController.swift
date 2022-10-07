//
//  InformationViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/6/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class InformationViewController: NSObject {

    @objc
    static func show(vc: UIViewController,
                     instructions: String?,
                     key: String?,
                     reference: String,
                     name: String ) {
        let informationView = InformationView(instructions: instructions, key: key, reference: reference, name: name)
        let hostingVC = UIHostingController(rootView: informationView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
