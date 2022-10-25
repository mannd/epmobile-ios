//
//  InformationViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import UIKit

@objc
class InformationViewController: UIViewController {
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
