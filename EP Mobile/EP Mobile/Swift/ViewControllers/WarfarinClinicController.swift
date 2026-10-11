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
    static let name = "Warfarin Clinic"

    @objc
    static func show(vc: UIViewController) {
        let warfarinClinicView = WarfarinClinicView()
        let hostingVC = UIHostingController(rootView: warfarinClinicView)
        hostingVC.title = name

        let informationView = InformationView(instructions: Warfarin.getInstructions(), references: Warfarin.getReferences(), name: name)
        InformationViewPresenter.addInfoButton(to: hostingVC, infoView: informationView)
        
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
