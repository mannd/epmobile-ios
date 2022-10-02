//
//  RiskScoreView.swift
//  EP Mobile
//
//  Created by David Mann on 9/30/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct RiskScoreView: View {
    @State private var showInfo = false
    @State private var showResult = false
    @State private var resultCopied = false
    @State var selectKeeper = Set<Int>()
    @State private var result: String? = nil
    @State private var detailedResult: String? = nil

    var riskScore: EPSRiskScore = EPSChadsRiskScore()

    var body: some View {
        NavigationView {
            VStack {
                List(selection: $selectKeeper) {
                    ForEach(0..<riskScore.getArray().count, id: \.self) { x in
                        if let riskFactor = riskScore.getArray().object(at: x) as? EPSRiskFactor {
                            if riskFactor.details == "" {
                                Text("\(riskFactor.name)").font(.headline)
                            } else {
                                VStack(alignment: .leading) {
                                    Text("\(riskFactor.name)").font(.headline)
                                    Text("\(riskFactor.details)").font(.subheadline)
                                }
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(EditMode.active))
                HStack() {
                    Group() {
                        Button("Calculate") {
                            calculate()
                        }
                        Button("Clear") {
                            clear()
                        }
                    }
                    .roundedButton()
                }
            }
            .navigationBarTitle(Text(riskScore.getName()), displayMode: .inline)
            .navigationBarItems(trailing:  AnyView(Button(action: { showInfo.toggle() }) {
                Image(systemName: "info.circle")
            }.sheet(isPresented: $showInfo) {
               InfoView(riskScore: riskScore)
            }))
            .navigationViewStyle(StackNavigationViewStyle())
            .alert("Result", isPresented: $showResult, actions: {
                Button("OK", role: .cancel, action: {})
                Button("Copy result") {
                    let pasteboard = UIPasteboard()
                    pasteboard.string = detailedResult
                    resultCopied = true
                }

            }, message: { Text(result ?? "Error") })
            .alert("Result Copied", isPresented: $resultCopied, actions: {}, message: { Text("Result copied to clipboard.")})
        }
    }

    func calculate() {
        if let riskArray = riskScore.getArray() as? [EPSRiskFactor] {
            for i in selectKeeper {
                riskArray[i].isSelected = true
            }
            let mutableRiskArray = NSMutableArray(array: riskArray)
            let score = riskScore.calculate(mutableRiskArray)
            let message = riskScore.getMessage(score)
            result = message
            detailedResult = riskScore.getFullRiskReport(fromMessage: message, andRisks: riskArray)
            showResult = true
        }

    }

    func clear() {
        selectKeeper.removeAll()
    }
}

private struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    var riskScore: EPSRiskScore = EPSChadsRiskScore()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    if let instructions = riskScore.getInstructions() {
                        Section(header: Text("Instructions")) {
                            Text(instructions)
                        }
                    }
                    // Note that hyperlinks don't appear when Text is used with a variable, unless you do this...
                    Section(header: Text("Reference")) {
                        Text(LocalizedStringKey(riskScore.getReference()))
                    }
                }
                Button("Done") {
                    dismiss()
                }
                .frame(width: 140, height: 40)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(15)
                .padding()
            }
            .navigationBarTitle(Text(riskScore.getName()), displayMode: .inline)
        }
    }
}

struct RiskScoreView_Previews: PreviewProvider {
    static var previews: some View {
        RiskScoreView()
        InfoView()
    }
}
