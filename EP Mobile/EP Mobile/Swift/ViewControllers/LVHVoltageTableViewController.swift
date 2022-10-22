//
//  LVHVoltageTableViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/21/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import UIKit

class LVHVoltageTableViewController: UITableViewController {

    override func viewDidLoad() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showNotes), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }

    @objc
    func showNotes() {
        let informationView = InformationView(references: [Reference("Hsieh BP, Pham MX, Froelicher VF. Prognostic value of electrocardiographic criteria for left ventricular hypertrophy. American Heart Journal. 2005;150(1):161-167.\ndoi:10.1016/j.ahj.2004.08.041")], name: "LVH Voltage Criteria")
        InformationViewController.show(vc: self, informationView: informationView)
    }
}
