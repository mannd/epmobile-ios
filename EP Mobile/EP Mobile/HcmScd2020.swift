//
//  HcmScd2020View.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "HCM SCD 2020"

struct HcmScd2020View: View {
    // Major risks
    @State private var familyHxScd: Bool = false
    @State private var massiveLVH: Bool = false
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
                        }
                        Toggle(isOn: $massiveLVH) {
                            Text("Massive LVH")
                        }
                        Toggle(isOn: $hxSyncope) {
                            Text("Unexplained Syncope")
                        }
                        Toggle(isOn: $apicalAneurysm) {
                            Text("Apical Aneurysm")
                        }
                        Toggle(isOn: $lowLVEF) {
                            Text("LVEF ≤ 50%")
                        }
                    }
                    Section(header: Text("Minor Risks")) {
                        Toggle(isOn: $hxNsvt) {
                            Text("Hx NSVT")
                        }
                        Toggle(isOn: $extensiveLGE) {
                            Text("Extensive LGE on CMR")
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
            .navigationBarItems(trailing: NavigationLink(destination: InformationView(instructions: HcmModel.getInstructions(), key: HcmModel.getKey(), references: HcmModel.getReferences(), name: calculatorName), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
//            .navigationBarItems(trailing:
//                                    Button(action: { showInfo.toggle() }) {
//                Image(systemName: "info.circle")
//            }).sheet(isPresented: $showInfo) {
//                Info()
//            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
//        textFieldIsFocused = false
//        let viewModel = HcmViewModel(age: Int(age), thickness: Int(thickness), laDiameter: Int(laDiameter), gradient: Int(gradient), familyHxScd: familyHxScd, hxNsvt: hxNsvt, hxSyncope: hxSyncope)
//        result = viewModel.calculate()
//        detailedResult = viewModel.getDetails()
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
