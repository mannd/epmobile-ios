//
//  FrailtyView.swift
//  EP Mobile
//
//  Created by David Mann on 10/18/23.
//  Copyright © 2023 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "Groningen Frailty Indicator"

struct FrailtyView: View {
    @State private var shopping:Bool = false
    @State private var result: String = ""
    @State private var detailedResult: String = ""
    @State private var showInfo: Bool = false

    @State var frailtyModel = FrailtyModel()

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
                    Section(header: Text("Mobility")) {
                        Text("Is the patient able to carry out these tasks single handed without any help? (The use of help resources such as walking stick, walking frame, wheelchair, is considered independent)").bold().italic()
                        List {
                            YesNoPicker(value: $frailtyModel.shopping.value, label: frailtyModel.shopping.question)
                            YesNoPicker(value: $frailtyModel.walkingOutside.value, label: frailtyModel.walkingOutside.question)
                            YesNoPicker(value: $frailtyModel.dressing.value, label: frailtyModel.dressing.question)
                            YesNoPicker(value: $frailtyModel.goingToToilet.value, label: frailtyModel.goingToToilet.question)
                        }
                        .pickerStyle(.automatic)
                    }
                    Section(header: Text("Physical Fitness")) { 
                        Picker(selection: $frailtyModel.fitness.value, label: Text(frailtyModel.fitness.question)) {
                            ForEach (0...10, id:\.self) { number in
                                Text("\(number)")
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                    Section(header: Text("Vision")) { }
                    Section(header: Text("Hearing")) { }
                    Section(header: Text("Nourishment")) { }
                    Section(header: Text("Morbidity")) { }
                    Section(header: Text("Cognition")) { }
                    Section(header: Text("Psychosocial")) { }
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
            .onChange(of: shopping, perform: { _ in clearResult() })
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: InformationView(instructions: FrailtyModel.getInstructions(), key: FrailtyModel.getKey(), references: FrailtyModel.getReferences(), name: calculatorName), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        textFieldIsFocused = false
    }

    func clear() {
        shopping = false
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

struct YesNoPicker: View {
    @Binding var value: Int
    var label: String

    var body: some View {
        Picker(selection: $value, label:
                Text(label))
        { 
            Text("No")
            Text("Yes")
        }
    }
}

struct YesSomtimesNoPicker: View {
    @Binding var value: Int
    var label: String

    var body: some View {
        Picker(selection: $value, label:
                Text(label))
        { 
            Text("No")
            Text("Sometimes")
            Text("Yes")
        }
    }
}



#Preview {
    FrailtyView()
}

