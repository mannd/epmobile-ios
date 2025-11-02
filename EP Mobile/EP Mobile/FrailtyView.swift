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
    @State private var result: String = ""
    @State private var detailedResult: String = ""
    @State private var showInfo: Bool = false

    @State var model = FrailtyModel()

    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text(FrailtyModel.mobilityHeader)) {
                        Text(FrailtyModel.mobilityQuestion).italic()
                        List {
                            YesNoPicker(value: $model.shopping.value, label: model.shopping.question, firstLabel: "Independent", secondLabel: "Dependent")
                            YesNoPicker(value: $model.walkingOutside.value, label: model.walkingOutside.question, firstLabel: "Independent", secondLabel: "Dependent")
                            YesNoPicker(value: $model.dressing.value, label: model.dressing.question, firstLabel: "Independent", secondLabel: "Dependent")
                            YesNoPicker(value: $model.goingToToilet.value, label: model.goingToToilet.question, firstLabel: "Independent", secondLabel: "Dependent")
                        }
                    }
                    Section(header: Text(FrailtyModel.fitnessHeader)) {
                        Picker(selection: $model.fitness.value, label: Text(model.fitness.question)) {
                            ForEach (0...10, id:\.self) { number in
                                Text("\(number)")
                            }
                        }
                    }
                    Section(header: Text(FrailtyModel.visionHeader)) {
                        YesNoPicker(value: $model.poorVision.value, label: model.poorVision.question)

                    }
                    Section(header: Text(FrailtyModel.hearingHeader)) { 
                        YesNoPicker(value: $model.poorHearing.value, label: model.poorHearing.question)
                    }
                    Section(header: Text(FrailtyModel.nourishmentHeader)) {
                        YesNoPicker(value: $model.weightLoss.value, label: model.weightLoss.question)
                    }
                    Section(header: Text(FrailtyModel.morbidityHeader)) {
                        YesNoPicker(value: $model.multipleMeds.value, label: model.multipleMeds.question)
                    }
                    Section(header: Text(FrailtyModel.cognitionHeader)) {
                        YesSomtimesNoPicker(value: $model.poorMemory.value, label: model.poorMemory.question)
                    }
                    Section(header: Text(FrailtyModel.psychosocialHeader)) {
                        YesSomtimesNoPicker(value: $model.feelEmpty.value, label: model.feelEmpty.question)
                        YesSomtimesNoPicker(value: $model.missPeople.value, label: model.missPeople.question)
                        YesSomtimesNoPicker(value: $model.feelAbandoned.value, label: model.feelAbandoned.question)
                        YesSomtimesNoPicker(value: $model.feelSad.value, label: model.feelSad.question)
                        YesSomtimesNoPicker(value: $model.feelNervous.value, label: model.feelNervous.question)
                    }
                    Section(header: Text("Result")) {
                        HStack {
                            Text(result).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Button("Copy") {
                                copy()
                            }
                        }
                    }
                }
                .pickerStyle(.automatic)
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: model, perform: { _ in clearResult() })
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
                InformationView(instructions: FrailtyModel.getInstructions(), key: FrailtyModel.getKey(), references: FrailtyModel.getReferences(), name: calculatorName)
            }
        }
    }

    func calculate() {
        do {
            try model.validateEntries()
            result = "\(model.calculate())"
            detailedResult = model.getDetails()
        } catch {
            if let error = error as? FrailtyError {
                result = error.description
            }
            result = ErrorMessage.unknownError

        }
    }

    func clear() {
        model = FrailtyModel()
        clearResult()
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
    var firstLabel: String = "No"
    var secondLabel: String = "Yes"

    var body: some View {
        Picker(selection: $value, label:
                Text(label))
        { 
            Text(firstLabel).tag(0)
            Text(secondLabel).tag(1)
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
            Text("No").tag(0)
            Text("Sometimes").tag(1)
            Text("Yes").tag(2)
        }
    }
}



#Preview {
    FrailtyView()
}

