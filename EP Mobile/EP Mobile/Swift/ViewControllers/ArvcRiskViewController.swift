//
//  ArvcRiskViewController.swift
//  EP Mobile
//
//  Created by David Mann on 4/19/19.
//  Copyright © 2019 EP Studios. All rights reserved.
//

import UIKit

// This is a Massive View Controller and should be refactored by extracting the risk score model.
class ArvcRiskViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var syncopeSwitch: UISwitch!
    @IBOutlet weak var twiSlider: UISlider!
    @IBOutlet weak var twiLabel: UILabel!
    @IBOutlet weak var pvcCountTextField: UITextField!
    @IBOutlet weak var nsvtSwitch: UISwitch!
    @IBOutlet weak var rvefSlider: UISlider!
    @IBOutlet weak var rvefLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var disclaimerLabel: UILabel!
    var activeField: UITextField?
    let errorTitle = "Error"
    let resultTitle = "Risk of sustained ventricular arrhythmia"
    let riskScoreTitle = "ARVC Risk"

    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.title = riskScoreTitle
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showNotes), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
        twiSlider.addTarget(self, action: #selector(updateTWI), for: UIControl.Event.valueChanged)
        rvefSlider.addTarget(self, action: #selector(updateRVEF), for: UIControl.Event.valueChanged)
        initFields()
        pvcCountTextField.delegate = self
        ageTextField.delegate = self
        registerForKeyboardNotifications()
    }

    override
    func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
        super.viewDidDisappear(animated)
    }

    @objc func updateTWI(sender: UISlider) {
        twiLabel.text = "\(Int(sender.value))"
    }

    @objc func updateRVEF(sender: UISlider) {
        rvefLabel.text = "\(Int(sender.value))"
    }

    private func initFields() {
        twiSlider.value = 0
        twiLabel.text = "0"
        rvefSlider.value = 50
        rvefLabel.text = "50"
        ageTextField.text = ""
        pvcCountTextField.text = ""
        sexSegmentedControl.selectedSegmentIndex = 0
        syncopeSwitch.isOn = false
        nsvtSwitch.isOn = false

    }

    @IBAction func cancel(_ sender: Any) {
        initFields()
    }

    @IBAction func calculate(_ sender: Any) {
        calculateRisk()
    }

    @objc func calculateRisk() {
        guard let age = ageTextField.text, !age.isEmpty,
            let pvcCount = pvcCountTextField.text, !pvcCount.isEmpty else {
                showError("Empty input fields.  Make sure you have entered an age and PVC count.")
                return
        }
        guard let ageValue = Int(age), let pvcCountValue = Int(pvcCount) else {
            showError("Age and PVC count must be whole numbers.")
            return
        }
        if ageValue < 14 || ageValue > 90 {
            showError("Age must be between 14 and 90")
            return
        }
        if pvcCountValue < 0 || pvcCountValue > 100_000 {
            showError("PVC count must be between 0 and 100000")
            return
        }
        let sex = sexSegmentedControl.selectedSegmentIndex
        let syncope = syncopeSwitch.isOn ? 1 : 0
        let numTWI = Int(twiSlider.value)
        let hxNSVT = nsvtSwitch.isOn ? 1 : 0
        let rvef = Int(rvefSlider.value)
        let model = ArvcRiskModel(sex: sex, age: ageValue, hxSyncope: syncope, hxNSVT: hxNSVT, pvcCount: pvcCountValue, twiCount: numTWI, rvef: rvef)
        let risk = model.calculateRisk()
        let yr5Risk = risk.year5Risk
        let yr2Risk = risk.year2Risk
        let yr1Risk = risk.year1Risk
        showResult("\(yr5Risk)% risk in 5 years\n\(yr2Risk)% risk in 2 years\n\(yr1Risk)% risk in 1 year")
    }

    func showResult(_ result: String) {
        EPSSharedMethods.showDialog(withTitle: resultTitle, andMessage: result, inView: self)
    }

    func showError(_ message: String) {
        EPSSharedMethods.showDialog(withTitle: errorTitle, andMessage: message, inView: self)
    }

    @objc
    func showNotes() {
        let instructions = ArvcRiskModel.getInstructions()
        let references = ArvcRiskModel.getReferences()
        InformationViewPresenter.show(vc: self, instructions: instructions, key: nil, references: references, name: riskScoreTitle)
    }

    // Respond to pressing Done button on keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    // This boilerplate code modified from https://stackoverflow.com/questions/52316676/type-nsnotification-name-has-no-member-keyboarddidshownotification
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        self.view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
