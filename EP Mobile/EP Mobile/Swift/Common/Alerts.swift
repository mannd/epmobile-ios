//
//  Alerts.swift
//  EP Mobile
//
//  Created by David Mann on 11/8/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import UIKit

@objc
extension UIViewController {
    @objc
    func showCopyResultAlert(title: String, message: String, references: [Reference]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { _ in }
        let copyAction: UIAlertAction = UIAlertAction(title: "Copy result", style: .default) { _ in
            let pasteboard = UIPasteboard.general
            pasteboard.string = getDetailedResults()
            let confirmationAlert = UIAlertController(title: "Result Copied", message: "Result copied to clipboard.", preferredStyle: .alert)
            confirmationAlert.addAction(defaultAction)
            self.present(confirmationAlert, animated: true)
        }
        alert.addAction(defaultAction)
        alert.addAction(copyAction)
        self.present(alert, animated: true)

        func getDetailedResults() -> String {
            var referenceLabel = "Reference"
            if references.count > 1 {
                referenceLabel += "s"
            }
            referenceLabel += ":"
            var referenceList = ""
            for ref in references {
                referenceList += ref.getPlainTextReference() + "\n"
            }
            return "\(title)\n\(message)\n\(referenceLabel)\n\(referenceList)"
        }
    }
}


