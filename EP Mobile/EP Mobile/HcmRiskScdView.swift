//
//  HcmRiskScdView.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "HCM Risk-SCD 2014"

struct HcmRiskScdView: View {
    @State private var age: Double = 0
    @State private var thickness: Double = 0
    @State private var laDiameter: Double = 0
    @State private var gradient: Double = 0
    @State private var familyHxScd: Bool = false
    @State private var hxNsvt: Bool = false
    @State private var hxSyncope: Bool = false
    @State private var result: String = ""
    @State private var detailedResult: String = ""
    @State private var showInfo: Bool = false

    @FocusState private var textFieldIsFocused: Bool

    fileprivate static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Parameters")) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Age (yrs)")
                                TextField("16-115 yrs", value: $age, formatter: Self.numberFormatter)
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.trailing)
                                    .focused($textFieldIsFocused)
                            }
                            DescriptionView(HcmRiskScdModel.ageDescription)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("LV wall thickness (mm)")
                                TextField("10-35 mm", value: $thickness, formatter: Self.numberFormatter)
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.trailing)
                                    .focused($textFieldIsFocused)
                            }
                            DescriptionView(HcmRiskScdModel.thicknessDescription)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("LA diameter (mm)")
                                TextField("28-67 mm", value: $laDiameter, formatter: Self.numberFormatter)
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.trailing)
                                    .focused($textFieldIsFocused)
                            }
                            DescriptionView(HcmRiskScdModel.laDiameterDescription)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Gradient (mmHg)")
                                TextField("2-154 mmHg", value: $gradient, formatter: Self.numberFormatter)
                                    .keyboardType(.numbersAndPunctuation)
                                    .multilineTextAlignment(.trailing)
                                    .focused($textFieldIsFocused)
                            }
                            DescriptionView(HcmRiskScdModel.gradientDescription)
                        }
                    }
                    Section(header: Text("History")) {
                        ToggleView(parameter: $familyHxScd, label: "Family hx SCD", description: HcmRiskScdModel.familyHxScdDescription)
                        ToggleView(parameter: $hxNsvt, label: "Hx NSVT", description: HcmRiskScdModel.hxNsvtDescription)
                        ToggleView(parameter: $hxSyncope, label: "Hx syncope", description: HcmRiskScdModel.hxSyncopeDescription)
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
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: InformationView(instructions: HcmRiskScdModel.getInstructions(), key: HcmRiskScdModel.getKey(), references: HcmRiskScdModel.getReferences(), name: calculatorName), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        textFieldIsFocused = false
        let viewModel = HcmRiskScdViewModel(age: Int(age), thickness: Int(thickness), laDiameter: Int(laDiameter), gradient: Int(gradient), familyHxScd: familyHxScd, hxNsvt: hxNsvt, hxSyncope: hxSyncope)
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



struct HcmView_Previews: PreviewProvider {
    static var previews: some View {
        HcmRiskScdView()
    }
}

