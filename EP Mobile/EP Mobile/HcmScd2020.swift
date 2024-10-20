//
//  HcmScd2020View.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "HCM SCD 2020 (AHA/ACC)"

struct HcmScd2020View: View {
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
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Major Risks")) {
                        Toggle(isOn: $familyHxScd) {
                            Text("Family hx SCD")
                            Text("Sudden death judged definitively or likely attributable to HCM in ≥1 first-degree or close relatives who are ≤50 years of age").font(.caption2)
                        }
                        Toggle(isOn: $massiveLVH) {
                            Text("Massive LVH")
                            Text("≥ 30 mm in any LV segment").font(.caption2)
                        }
                        Toggle(isOn: $hxSyncope) {
                            Text("Unexplained Syncope")
                            Text("≥1 Recent episodes of syncope suspected by clinical history to be arrhythmic (ie, unlikely to be of neurocardiogenic [vasovagal] etiology, or related to LVOTO).").font(.caption2)
                        }
                        Toggle(isOn: $apicalAneurysm) {
                            Text("Apical Aneurysm")
                            Text("Independent of size").font(.caption2)
                        }
                        Toggle(isOn: $lowLVEF) {
                            Text("LVEF ≤ 50%")
                            Text("By echo or CMR imaging.").font(.caption2)
                        }
                    }
                    Section(header: Text("Minor Risks")) {
                        Toggle(isOn: $hxNsvt) {
                            Text("Nonsustained VT")
                            Text("Present on ambulatory monitoring").font(.caption2)
                        }
                        Toggle(isOn: $extensiveLGE) {
                            Text("Extensive LGE on CMR")
                            Text("≥15% of LV mass").font(.caption2)
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
            .onChange(of: familyHxScd, perform: { _ in clearResult() })
            .onChange(of: massiveLVH, perform: { _ in clearResult() })
            .onChange(of: hxSyncope, perform: { _ in clearResult() })
            .onChange(of: apicalAneurysm, perform: { _ in clearResult() })
            .onChange(of: lowLVEF, perform: { _ in clearResult() })
            .onChange(of: hxNsvt, perform: { _ in clearResult() })
            .onChange(of: extensiveLGE, perform: { _ in clearResult() })
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: InformationView(instructions: HcmScd2020Model.getInstructions(), key: HcmScd2020Model.getKey(), references: HcmScd2020Model.getReferences(), name: calculatorName), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        textFieldIsFocused = false
        let viewModel = HcmScd2020ViewModel(familyHxScd: familyHxScd, massiveLVH: massiveLVH, hxSyncope: hxSyncope, apicalAneurysm: apicalAneurysm, lowLVEF: lowLVEF, hxNsvt: hxNsvt, extensiveLGE: extensiveLGE)
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
        HcmScd2020View()
    }
}
