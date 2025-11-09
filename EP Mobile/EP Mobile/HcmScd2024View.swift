//
//  HcmScd2024View.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "HCM SCD 2024 (AHA/ACC)"

struct HcmScd2024View: View {
    // Major risks
    @State private var familyHxScd: Bool = false
    @State private var massiveLVH: Bool = false
    @State private var thickness: Double = 0
    @State private var hxSyncope: Bool = false
    @State private var apicalAneurysm: Bool = false
    @State private var lowLVEF: Bool = false

    // Minor risks
    @State private var hxNsvt: Bool = false
    @State private var extensiveLGE: Bool = false

    // Results
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

    var body: some View {
        NavigationStack {
            VStack {
                Form() {
                    Section(header: Text("Major Risks")) {
                        ToggleView(parameter: $familyHxScd, label: "Family hx SCD", description: "Sudden death judged definitively or likely attributable to HCM in ≥1 first-degree or close relatives who are ≤50 years of age")
                        ToggleView(parameter: $massiveLVH, label: "Massive LVH", description: "Massive LVH (≥ 30 mm in any LV segment)")
                        ToggleView(parameter: $hxSyncope, label: "Unexplained syncope", description: "≥1 Recent episodes of syncope suspected by clinical history to be arrhythmic (ie, unlikely to be of neurocardiogenic [vasovagal] etiology, or related to LVOTO).")
                        ToggleView(parameter: $apicalAneurysm, label: "Apical aneurysm", description: "With transmural scar or LGE")
                        ToggleView(parameter: $lowLVEF, label: "LVEF ≤ 50%", description: "By echo or CMR imaging.")
                    }
                    Section(header: Text("Minor Risks")) {
                        ToggleView(parameter: $hxNsvt, label: "Nonsustained VT", description: "Present on ambulatory monitoring")
                        ToggleView(parameter: $extensiveLGE, label: "Extensive LGE on CMR", description: "≥15% of LV mass")
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
            .onChange(of: familyHxScd, perform: { _ in clearResult() })
            .onChange(of: massiveLVH, perform: { _ in clearResult() })
            .onChange(of: hxSyncope, perform: { _ in clearResult() })
            .onChange(of: apicalAneurysm, perform: { _ in clearResult() })
            .onChange(of: lowLVEF, perform: { _ in clearResult() })
            .onChange(of: hxNsvt, perform: { _ in clearResult() })
            .onChange(of: extensiveLGE, perform: { _ in clearResult() })
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .navigationDestination(isPresented: $showInfo) {
                InformationView(instructions: HcmScd2024Model.getInstructions(), key: HcmScd2024Model.getKey(), references: HcmScd2024Model.getReferences(), name: calculatorName)
            }
        }
    }

    func calculate() {
        textFieldIsFocused = false
        let viewModel = HcmScd2024ViewModel(familyHxScd: familyHxScd, massiveLVH: massiveLVH, hxSyncope: hxSyncope, apicalAneurysm: apicalAneurysm, lowLVEF: lowLVEF, hxNsvt: hxNsvt, extensiveLGE: extensiveLGE)
        result = viewModel.calculate()
        detailedResult = viewModel.getDetails()
    }

    func clear() {
        textFieldIsFocused = false
        clearResult()

        familyHxScd = false
        massiveLVH = false
        hxSyncope = false
        apicalAneurysm = false
        lowLVEF = false
        hxNsvt = false
        extensiveLGE = false
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

struct HcmScd2020View_Previews: PreviewProvider {
    static var previews: some View {
        HcmScd2024View()
    }
}
