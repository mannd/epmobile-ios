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
        super.viewDidLoad()
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showNotes), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }

    @objc
    func showNotes() {
        let informationView = InformationView(references: [Reference("Hsieh BP, Pham MX, Froelicher VF. Prognostic value of electrocardiographic criteria for left ventricular hypertrophy. American Heart Journal. 2005;150(1):161-167.\ndoi:10.1016/j.ahj.2004.08.041"), Reference("Peguero JG, Lo Presti S, Perez J, Issa O, Brenes JC, Tolentino A. Electrocardiographic Criteria for the Diagnosis of Left Ventricular Hypertrophy. J Am Coll Cardiol. 2017;69(13):1694-1703. doi:10.1016/j.jacc.2017.01.037"), Reference("Yu Z, Song J, Cheng L, et al. Peguero-Lo Presti criteria for the diagnosis of left ventricular hypertrophy: A systematic review and meta-analysis. PLoS One. 2021;16(1):e0246305. doi:10.1371/journal.pone.0246305")], name: "LVH Voltage Criteria")
        InformationViewPresenter.show(vc: self, informationView: informationView)
    }
}
