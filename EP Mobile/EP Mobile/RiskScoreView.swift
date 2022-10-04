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

    var riskScore: EPSRiskScore = EPSHcmRiskScore()

    var body: some View {
        NavigationView {
            VStack {
                riskScore.numberOfSections() == 1 ?
                AnyView(RiskScoreList(selectKeeper: $selectKeeper, array: riskScore.getArray()))
                :
                AnyView(GroupedRiskScoreList(selectKeeper: $selectKeeper, riskScore: riskScore, array: riskScore.getArray(), numSections: Int(riskScore.numberOfSections())))
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .listStyle(.grouped)
//            .headerProminence(.increased)
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

private struct RiskScoreList: View {
    @Binding var selectKeeper: Set<Int>
    var array: NSMutableArray
    var body: some View {
        List(selection: $selectKeeper) {
            Section(header: Text("RISKS")) {
                ForEach(0..<array.count, id: \.self) { x in
                    if let riskFactor = array.object(at: x) as? EPSRiskFactor {
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
        }
        .environment(\.editMode, .constant(EditMode.active))
    }
}

private struct GroupedRiskScoreList: View {
    @Binding var selectKeeper: Set<Int>
    var riskScore: EPSRiskScore
    var array: NSMutableArray
    let numSections: Int

    var body: some View {
        List(selection: $selectKeeper) {
            ForEach(0..<numSections, id: \.self) { sectionNumber in
                Section(header: Text(riskScore.getTitleForHeaderSection(sectionNumber))) {
                    ForEach(Int(riskScore.getOffset(sectionNumber))..<Int(riskScore.getOffset(sectionNumber) + riskScore.numberOfRows(inSection: sectionNumber)), id: \.self) { x in
                        if let riskFactor = array.object(at: x) as? EPSRiskFactor {
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
            }
//            ForEach(0..<array.count, id: \.self) { x in
//                if let riskFactor = array.object(at: x) as? EPSRiskFactor {
//                    if riskFactor.details == "" {
//                        Text("\(riskFactor.name)").font(.headline)
//                    } else {
//                        VStack(alignment: .leading) {
//                            Text("\(riskFactor.name)").font(.headline)
//                            Text("\(riskFactor.details)").font(.subheadline)
//                        }
//                    }
//                }
//            }
        }
        .environment(\.editMode, .constant(EditMode.active))
    }
}

private struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    var riskScore: EPSRiskScore

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    if let instructions = riskScore.getInstructions() {
                        Section(header: Text("Instructions")) {
                            Text(instructions)
                        }
                    }
                    if let key = riskScore.getKey() {
                        Section(header: Text("Key")) {
                            Text(key)
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
        RiskScoreView(riskScore: EPSChadsRiskScore())
        RiskScoreView(riskScore: EPSHcmRiskScore())
        InfoView(riskScore: EPSChadsRiskScore())
        InfoView(riskScore: EPSHcmRiskScore())
    }
}
