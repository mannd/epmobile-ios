//
//  InformationViewPresenter.swift
//  EP Mobile
//
//  Created by David Mann on 10/6/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

@objc
final class InformationViewPresenter: NSObject {

    @objc
    static func show(vc: UIViewController,
                     instructions: String?,
                     key: String?,
                     references: [Reference],
                     name: String
    ) {
        let informationView = InformationView(instructions: instructions, key: key, references: references, name: name)
        let hostingVC = UIHostingController(rootView: informationView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
    
    @objc
    static func show(vc: UIViewController,
                     instructions: String?,
                     key: String?,
                     references: [Reference],
                     name: String,
                     optionalSectionTitle: String?,
                     optionalSectionText: String?
    ) {
        let informationView = InformationView(instructions: instructions, key: key, references: references, name: name, optionalSectionTitle: optionalSectionTitle, optionalSectionText: optionalSectionText)
        Self.show(vc: vc, informationView: informationView)
    }

    static func show(vc: UIViewController, informationView: InformationView) {
        let hostingVC = UIHostingController(rootView: informationView)
        vc.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
