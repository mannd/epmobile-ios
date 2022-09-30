//
//  RiskScoreView.swift
//  EP Mobile
//
//  Created by David Mann on 9/30/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

var demoData = ["Phil Swanson", "Karen Gibbons", "Grant Kilman", "Wanda Green"]

struct RiskScoreView: View {
    @State private var showInfo = false
    @State var selectKeeper = Set<Int>()

    var riskScore: EPSRiskScore = EPSChadsRiskScore()

    var body: some View {
        NavigationView {
            VStack {
                List(selection: $selectKeeper) {
                    ForEach(0..<riskScore.getArray().count, id: \.self) { x in
                        Text("\((riskScore.getArray().object(at: x) as AnyObject).name)")
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
            }))
        }
    }

    func calculate() {
        // set selected risks accoring to selectKeeper in riskScore
        if let riskArray = riskScore.getArray() as? [EPSRiskFactor] {
            for i in selectKeeper {
                riskArray[i].isSelected = true
            }
            let mutableRiskArray = NSMutableArray(array: riskArray)
            let score = riskScore.calculate(mutableRiskArray)
            print("Score = \(score)")
        }

    }

    func clear() {
//        if let array = riskScore.getArray() as {
//            for x in array {
//
//
//            }
//        }
        selectKeeper.removeAll()
    }
}

struct RiskScoreView_Previews: PreviewProvider {
    static var previews: some View {
        RiskScoreView()
    }
}
