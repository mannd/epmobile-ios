//
//  HCMSCDTableViewController.swift
//  EP Mobile
//
//  Created by David Mann on 10/16/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import UIKit

class HCMSCDTableViewController: UITableViewController {
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        
        }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            RiskScoreViewController.show(vc: self, riskScore: EPSHcmRiskScore())
        case 1:
            HcmViewController.show(vc: self)

            //            [HcmViewController showWithVc:self];
        default: break

        }

    }
}
