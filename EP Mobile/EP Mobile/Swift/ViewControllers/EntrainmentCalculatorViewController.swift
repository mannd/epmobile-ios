//
//  EntrainmentCalculatorViewController.swift
//  EP Mobile
//
//  Created by David Mann on 5/19/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class EntrainmentCalculatorViewController: NSObject {

    @objc
    static func show(vc: UIViewController) {
        let entrainmentCalculatorView = EntrainmentCalculatorView()
        let hostingVC = UIHostingController(rootView: entrainmentCalculatorView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
