//
//  LQTTableViewController.swift
//  EP Mobile
//
//  Created by David Mann on 8/13/19.
//  Copyright © 2019 EP Studios. All rights reserved.
//

import UIKit

class LQTTableViewController: UITableViewController {

    var syndromes: Array<Syndrome> = []

    struct Syndrome {
        var subtype: String
        var channel: String
        var details: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")

        // Do any additional setup after loading the view.
        let array = [
            Syndrome(subtype: "LQT1", channel: "KCNQ1", details: "Encodes the α-subunit of the slow delayed rectifier potassium channel KV7.1 carrying the potassium current IKs."),
            Syndrome(subtype: "LQT2", channel: "KCNH2", details: "Also known as hERG. Encodes the α-subunit of the rapid delayed rectifier potassium channel KV11.1 carrying the potassium current IKr."),
            Syndrome(subtype: "LQT3", channel: "SCN5A", details: "Encodes the α-subunit of the cardiac sodium channel NaV1.5 carrying the sodium current INa."),
            Syndrome(subtype: "LQT4", channel: "ANK2", details: "Encodes Ankyrin B which anchors the ion channels in the cell. Disputed whether truly disease causing versus minor QT susceptibility gene."),
            Syndrome(subtype: "LQT5", channel: "KCNE1", details: "Encodes MinK, a potassium channel β-subunit. Heterozygous inheritance causes Romano-Ward, homozygous inheritance causes Jervell and Lange-Nielsen syndrome."),
            Syndrome(subtype: "LQT6", channel: "KCNE2", details: "Encodes MiRP1, a potassium channel β-subunit. Disputed whether truly disease causing versus minor QT susceptibility gene."),
            Syndrome(subtype: "LQT7", channel: "KCNJ2", details: "Encodes inward rectifying potassium current Kir2.1 carrying the potassium current IK1. Causes Andersen-Tawil syndrome."),
            Syndrome(subtype: "LQT8", channel: "CACNA1c", details: "Encodes the α-subunit CaV1.2 of the calcium channel Cav1.2 carrying the calcium current ICa(L). Causes Timothy syndrome."),
            Syndrome(subtype: "LQT9", channel: "CAV3", details: "Encodes Caveolin-3, responsible for forming membrane pouches known as caveolae. Mutations in this gene may increase the late sodium current INa."),
            Syndrome(subtype: "LQT10", channel: "SCN4B", details: "Encodes the β4-subunit of the cardiac sodium channel."),
            Syndrome(subtype: "LQT11", channel: "AKAP9", details: "Encodes A-kinase associated protein which interacts with KV7.1."),
            Syndrome(subtype: "LQT12", channel: "SNTA1", details: "Encodes syntrophin-α1. Mutations in this gene may increase the late sodium current INa."),
            Syndrome(subtype: "LQT13", channel: "KCNJ5", details: "Also known as GIRK4, encodes G protein-sensitive inwardly rectifying potassium channels (Kir3.4) which carry the potassium current IK(ACh)."),
            Syndrome(subtype: "LQT14", channel: "CALM1", details: "Encodes calmodulin-1, a calcium-binding messenger protein that interacts with the calcium current ICa(L)."),
            Syndrome(subtype: "LQT15", channel: "CALM2", details: "Encodes calmodulin-2, a calcium-binding messenger protein that interacts with the calcium current ICa(L)."),
            Syndrome(subtype: "LQT16", channel: "CALM3", details: "Encodes calmodulin-3, a calcium-binding messenger protein that interacts with the calcium current ICa(L)."),
            Syndrome(subtype: "LQT17", channel: "TRDN", details: "Encodes triadin, associated with the release of calcium from the sarcoplastic reticulum.  Causes exercise-induced cardiac arrest in young children."),
        ]
        syndromes = array
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syndromes.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "longQtsCell", for: indexPath) as! LQTTableViewCell
        let syndrome = syndromes[indexPath.row]
        cell.subtypeLabel?.text = syndrome.subtype
        cell.channelLabel?.text = syndrome.channel
        cell.detailsLabel?.text = syndrome.details
        return cell
    }

}
