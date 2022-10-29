//
//  EntrainmentCalculatorView.swift
//  EP Mobile
//
//  Created by David Mann on 5/19/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "Entrainment Map"

struct EntrainmentCalculatorView: View {
    @State private var tcl: Double = 0
    @State private var ppi: Double = 0
    @State private var concealedFusion: Bool = false
    @State private var sQrs: Double = 0
    @State private var egQrs: Double = 0
    @State private var result = ""
    @State private var showingInfo = false
    @FocusState private var textFieldIsFocused: Bool

    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.minimum = NSNumber(value: 0)
        formatter.maximum = NSNumber(value: 1000)
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Tachycardia CL and PPI")) {
                        HStack {
                            Text("Tachycardia CL")
                            TextField("TCL (msec)", value: $tcl, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("Post-pacing interval")
                            TextField("PPI (msec)", value: $ppi, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                    }
                    Section(header: Text("Concealed fusion")) {
                        Toggle(isOn: $concealedFusion) {
                            Text("Concealed fusion")
                        }
                        HStack {
                            Text("Stim-QRS")
                                .foregroundColor(concealedFusion ? .primary : Color.secondary)
                            TextField("S-QRS (msec)", value: $sQrs, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        .disabled(!concealedFusion)
                        HStack {
                            Text("EG-QRS")
                                .foregroundColor(concealedFusion ? .primary : Color.secondary)
                            TextField("EG-QRS (msec)", value: $egQrs, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        .disabled(!concealedFusion)
                    }
                    Section(header: Text("Result")) {
                        Text(result)
                    }
                }
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: tcl, perform: { _ in clearResult() })
            .onChange(of: ppi, perform: { _ in clearResult() })
            .onChange(of: concealedFusion, perform: { _ in
                textFieldIsFocused = false
                clearResult()
                sQrs = 0
                egQrs = 0
            })
            .onChange(of: sQrs, perform: { _ in clearResult() })
            .onChange(of: egQrs, perform: { _ in clearResult() })
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: InformationView(instructions: Entrainment.getInstructions(), references: Entrainment.getReferences(), name: calculatorName), isActive: $showingInfo) {
                Button(action: { showingInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        textFieldIsFocused = false
        print("sQrs", sQrs as Any)
        print("egQrs", egQrs as Any)
        let allowedSQrs = concealedFusion ? sQrs : nil
        let allowedEgQrs = concealedFusion ? egQrs : nil
        let viewModel = EntrainmentViewModel(tcl: tcl, ppi: ppi, concealedFusion: concealedFusion, sQrs: allowedSQrs, egQrs: allowedEgQrs)
        result = viewModel.calculate()
    }

    func clear() {
        textFieldIsFocused = false
        tcl = 0
        ppi = 0
        concealedFusion = false
        sQrs = 0
        egQrs = 0
        clearResult()
    }

    func clearResult() {
        result = ""
    }
}


struct EntrainmentCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        EntrainmentCalculatorView()
    }
}
