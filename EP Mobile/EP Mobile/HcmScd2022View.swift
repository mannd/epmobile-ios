//
//  HcmScd2022View.swift
//  EP Mobile
//
//  Created by David Mann on 10/16/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "HCM SCD 2022 (ESC)"

struct HcmScd2022View: View {
    @State private var age: Double = 0
    @State private var thickness: Double = 0
    @State private var laDiameter: Double = 0
    @State private var gradient: Double = 0
    @State private var familyHxScd: Bool = false
    @State private var hxNsvt: Bool = false
    @State private var hxSyncope: Bool = false

    @State private var apicalAneurysm: Bool = false
    @State private var lowLVEF: Bool = false
    @State private var extensiveLGE: Bool = false
    @State private var abnormalBP: Bool = false
    @State private var sarcomericMutation: Bool = false

    @State private var result: String = ""
    @State private var detailedResult: String = ""
    @State private var showInfo: Bool = false

    @FocusState private var textFieldIsFocused: Bool

    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // TODO: Note that the "other factors" aren't included in the risk assessment.  AHA online calculator adds "Nota bene: This estimate may not be accurate in the setting of Apical Aneurysm and Extensive LGE)"


    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("HCM Risk-ICD")) {
                        HStack {
                            Text("Age (yrs)")
                            TextField("16-115 yrs", value: $age, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("LV wall thickness (mm)")
                            TextField("10-35 mm", value: $thickness, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("LA diameter (mm)")
                            TextField("28-67 mm", value: $laDiameter, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("Gradient (mmHg)")
                            TextField("2-154 mmHg", value: $gradient, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        Toggle(isOn: $familyHxScd) {
                            Text("Family hx SCD")
                        }
                        Toggle(isOn: $hxNsvt) {
                            Text("Hx NSVT")
                        }
                        Toggle(isOn: $hxSyncope) {
                            Text("Hx Syncope")
                        }
                    }
                    Section(header: Text("Other factors")) {
                        Toggle(isOn: $apicalAneurysm) {
                            Text("Apical aneurysm")
                        }
                        Toggle(isOn: $lowLVEF) {
                            Text("LVEF ≤ 50%")
                        }
                        Toggle(isOn: $extensiveLGE) {
                            Text("Extensive LGE")
                        }
                        Toggle(isOn: $abnormalBP) {
                            Text("Abnormal BP")
                        }
                        Toggle(isOn: $sarcomericMutation) {
                            Text("Sarcomeric mutation")
                        }
                    }
                    Section(header: Text("Result")) {
                        HStack {
                            Text(result)
                            Spacer()
                            Button("Copy") {
                                copy()
                            }
                        }
                    }
                }
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: age, perform: { _ in clearResult() })
            .onChange(of: thickness, perform: { _ in clearResult() })
            .onChange(of: laDiameter, perform: { _ in clearResult() })
            .onChange(of: gradient, perform: { _ in clearResult() })
            .onChange(of: familyHxScd, perform: { _ in clearResult() })
            .onChange(of: hxNsvt, perform: { _ in clearResult() })
            .onChange(of: hxSyncope, perform: { _ in clearResult() })
            .onChange(of: apicalAneurysm, perform: { _ in clearResult() })
            .onChange(of: lowLVEF, perform: { _ in clearResult() })
            .onChange(of: extensiveLGE, perform: { _ in clearResult() })
            .onChange(of: abnormalBP, perform: { _ in clearResult() })
            .onChange(of: sarcomericMutation, perform: { _ in clearResult() })
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: InformationView(instructions: HcmScd2022Model.getInstructions(), key: HcmScd2022Model.getKey(), references: HcmScd2022Model.getReferences(), name: calculatorName), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        textFieldIsFocused = false
        let viewModel = HcmScd2022ViewModel(age: Int(age), thickness: Int(thickness), laDiameter: Int(laDiameter), gradient: Int(gradient), familyHxScd: familyHxScd, hxNsvt: hxNsvt, hxSyncope: hxSyncope, apicalAneurysm: apicalAneurysm, lowLVEF: lowLVEF, extensiveLGE: extensiveLGE, abnormalBP: abnormalBP, sarcomericMutation: sarcomericMutation)
        result = viewModel.calculate()
        detailedResult = viewModel.getDetails()
    }

    func clear() {
        textFieldIsFocused = false
        clearResult()
        age = 0
        thickness = 0
        laDiameter = 0
        gradient = 0
        familyHxScd = false
        hxNsvt = false
        hxSyncope = false
        apicalAneurysm = false
        lowLVEF = false
        abnormalBP = false
        extensiveLGE = false
        sarcomericMutation = false
    }

    func clearResult() {
        result = ""
        detailedResult = ""
    }

    func copy() {
        if !detailedResult.isEmpty {
            copyToClipboard(detailedResult)
        }
    }

    func copyToClipboard(_ s: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = s
    }
}

struct HcmScd2022_Previews: PreviewProvider {
    static var previews: some View {
        HcmScd2022View()
    }
}
