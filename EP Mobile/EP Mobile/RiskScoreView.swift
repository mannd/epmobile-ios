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
        NavigationStack {
            VStack {
                riskScore.numberOfSections() == 1 ?
                AnyView(RiskScoreList(selectKeeper: $selectKeeper, array: riskScore.getArray()))
                :
                AnyView(GroupedRiskScoreList(selectKeeper: $selectKeeper, riskScore: riskScore, array: riskScore.getArray(), numSections: Int(riskScore.numberOfSections())))
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .listStyle(.grouped)
            .navigationBarTitle(Text(riskScore.getName()), displayMode: .inline)
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
                InformationView(instructions: riskScore.getInstructions(), key: riskScore.getKey(), references: riskScore.getReferences() as! [Reference], name: riskScore.getName())
            }
            .alert("Result", isPresented: $showResult, actions: {
                Button("OK", role: .cancel, action: {})
                Button("Copy result") {
                    let pasteboard = UIPasteboard.general
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
            let risksSelected = riskScore.risksSelected(riskArray)
            detailedResult = riskScore.getFullRiskReport(fromMessage: message, andRisks: risksSelected)
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
                            Text(riskFactor.name).font(.headline)
                        } else {
                            VStack(alignment: .leading) {
                                Text(riskFactor.name).font(.headline)
                                Text(riskFactor.details).font(.subheadline)
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
                                Text(riskFactor.name).font(.headline)
                            } else {
                                VStack(alignment: .leading) {
                                    Text(riskFactor.name).font(.headline)
                                    Text(riskFactor.details).font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
        }
        .environment(\.editMode, .constant(EditMode.active))
    }
}

struct RiskScoreView_Previews: PreviewProvider {
    static var previews: some View {
        RiskScoreView(riskScore: EPSChadsRiskScore())
        RiskScoreView(riskScore: EPSHcmRiskScore())
    }
}
