//
//  InformationTableViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/29/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import UIKit

@objc
class InformationTableViewController: UITableViewController {
    @objc var instructions: String?
    @objc var key: String?
    @objc var name: String = ""
    @objc var references: [Reference] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showNotes), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }

    @objc
    func showNotes() {
        let informationView = InformationView(instructions: instructions, key: key, references: references, name: name)
        InformationViewPresenter.show(vc: self, informationView: informationView)
    }
}
