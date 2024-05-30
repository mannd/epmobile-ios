//
//  V2CalculatorView.swift
//  EP Mobile
//
//  Created by David Mann on 5/29/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "V2 Transition Calculator"

struct V2CalculatorView: View {
    @State private var rVT: Double = 0
    @State private var sVT: Double = 0
    @State private var rSR: Double = 0
    @State private var sSR: Double = 0
    @State private var showInfo: Bool = false
    @State private var result: String = ""
    @State var model = V2TransitionCalculator()

    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("VT or PVC")) {
                        HStack {
                            Text("R wave in V2")
                            TextField("0", value: $rVT, formatter: Self.numberFormatter)
                        }
                        HStack {
                            Text("S wave in V2")
                            TextField("0", value: $sVT, formatter: Self.numberFormatter)
                        }
                    }
                    Section(header: Text("Sinus rhythm")) {
                        HStack {
                            Text("R wave in V2")
                            TextField("0", value: $rSR, formatter: Self.numberFormatter)
                        }
                        HStack {
                            Text("S wave in V2")
                            TextField("0", value: $sSR, formatter: Self.numberFormatter)
                        }
                    }
                    Section(header: Text("Result")) {
                        HStack {
                            Text(result).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.trailing)
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: rVT, perform: { _ in clearResult() })
            .onChange(of: sVT, perform: { _ in clearResult() })
            .onChange(of: rSR, perform: { _ in clearResult() })
            .onChange(of: sSR, perform: { _ in clearResult() })
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: InformationView(instructions: V2TransitionCalculator.getInstructions(), key: V2TransitionCalculator.getKey(), references: V2TransitionCalculator.getReferences(), name: calculatorName), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        let params = V2TransitionParameters(rVT: rVT, sVT: sVT, rSR: rSR, sSR: sSR)
        let ratio = model.calculate(parameters: params)
        guard let ratio = ratio else {
            result = "INVALID"
            return
        }
        let ratioLessThan06 = ratio < 0.6
        var message = ratioLessThan06 ? "RVOT" : "LVOT"
        message = "VT location is \(message)"
        let ratioString = String(format: "%.2f", ratio)
        result = "V2 transition ration = \(ratioString)\n" + message
    }

    func clear() {
        rVT = 0
        sVT = 0
        rSR = 0
        sSR = 0
        clearResult()
    }

    private func clearResult() {
        result = ""
    }
}

#Preview {
    V2CalculatorView()
}
