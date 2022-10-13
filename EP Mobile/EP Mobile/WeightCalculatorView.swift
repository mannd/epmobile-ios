//
//  WeightCalculatorView.swift
//  EP Mobile
//
//  Created by David Mann on 5/10/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "Weight Calculator"

struct WeightCalculatorView: View {
    @State private var sex: EP_Mobile.Sex = .male
    @State private var weight: Double = 0.0
    @State private var height: Double = 0.0
    @State private var massUnit: MassUnit = .kg
    @State private var heightUnit: HeightUnit = .cm
    @State private var showInfo = false
    @State private var actualBodyWeightResult: String = ""
    @State private var idealBodyWeightResult: String = ""
    @State private var adjustedBodyWeightResult: String = ""
    @State private var recommendedBodyWeightResult: String = ""
    @State private var viewModel: WeightCalculatorViewModel? = nil
    @FocusState private var textFieldIsFocused: Bool

    @AppStorage(Keys.defaultMassUnit) var defaultMassUnit: String = Keys.kg
    @AppStorage(Keys.defaultHeightUnit) var defaultHeightUnit: String = Keys.centimeters

    var weightLabel: String { "Weight (\(massUnit.description))" }
    var heightLabel: String { "Height (\(heightUnit.description))"}

    private static let minimumWeight = 10.0
    private static let maximumWeight = 700.0
    private static let weightRange: ClosedRange<Double> = minimumWeight...maximumWeight
    private static var weightNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 1
        formatter.minimum = minimumWeight as NSNumber
        formatter.maximum = maximumWeight as NSNumber
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                // Using Form here gives a warning message about ambiguous constraints.
                // This is avoided by using List, but this seems to be an Apple bug
                // related to the embedded DatePicker.
                Form() {
                    Section(header: Text("Sex")) {
                        Picker(selection: $sex, label: Text("Sex")) {
                            ForEach(Sex.allCases) {
                                sex in Text(sex.description)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    Section(header: Text(weightLabel)) {
                        HStack {
                            TextField(weightLabel, value: $weight, formatter: Self.weightNumberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .focused($textFieldIsFocused)
                            Picker(selection: $massUnit, label: Text("Units")) {
                                ForEach(MassUnit.allCases) {
                                    unit in Text(unit.description)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    Section(header: Text(heightLabel)) {
                        HStack {
                            TextField(heightLabel, value: $height, formatter: Self.weightNumberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .focused($textFieldIsFocused)
                            Picker(selection: $heightUnit, label: Text("Units")) {
                                ForEach(HeightUnit.allCases) {
                                    unit in Text(unit.description)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    Section(header: Text("Actual Body Weight")) {
                        HStack {
                            Text(actualBodyWeightResult)
                            Spacer()
                            Button("Copy") {
                                copy(weightType: .actual)
                            }
                        }
                    }
                    Section(header: Text("Ideal Body Weight")) {
                        HStack {
                            Text(idealBodyWeightResult)
                            Spacer()
                            Button("Copy") {
                                copy(weightType: .ideal)
                            }
                        }
                    }
                    Section(header: Text("Adjusted Body Weight")) {
                        HStack {
                            Text(adjustedBodyWeightResult)
                            Spacer()
                            Button("Copy") {
                                copy(weightType: .adjusted)
                            }
                        }
                    }
                    Section(header: Text("Recommended Body Weight")) {
                        HStack {
                            Text(recommendedBodyWeightResult)
                            Spacer()
                            Button("Copy") {
                                copy(weightType: .recommended)
                            }
                        }
                    }
                }
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: sex, perform: { _ in  clearResult() })
            .onChange(of: weight, perform: { _ in  clearResult() })
            .onChange(of: height, perform: { _ in  clearResult() })
            .onChange(of: massUnit, perform: { _ in  clearResult() })
            .onChange(of: heightUnit, perform:  { _ in clearResult() })
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { showInfo.toggle() }) {
                Image(systemName: "info.circle")
            }.sheet(isPresented: $showInfo) {
                InformationView(instructions: Weight.getInstructions(), key: Weight.getKeys(), references: Weight.getReferences(), name: calculatorName, keyTitle: "Copy and Paste Weights")
            })
        }
        .onAppear() {
            if defaultMassUnit == Keys.kg {
                massUnit = .kg
            } else {
                massUnit = .lb
            }
            if defaultHeightUnit == Keys.inches {
                heightUnit = .inch
            } else {
                heightUnit = .cm
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }


    func calculate() {
        textFieldIsFocused = false
        let unitMass: UnitMass
        let unitLength: UnitLength
        switch massUnit {
        case .kg:
            unitMass = .kilograms
        case .lb:
            unitMass = .pounds
        }
        switch heightUnit {
        case .cm:
            unitLength = .centimeters
        case .inch:
            unitLength = .inches
        }
        let weightMeasurement = Measurement(value: weight, unit: unitMass)
        let heightMeasurement = Measurement(value: height, unit: unitLength)
        viewModel = WeightCalculatorViewModel(weight: weightMeasurement, height: heightMeasurement, sex: sex)
        if let viewModel = viewModel {
            actualBodyWeightResult = viewModel.actualBodyWeight()
            idealBodyWeightResult = viewModel.idealBodyWeight()
            adjustedBodyWeightResult = viewModel.adjustedBodyWeight()
            recommendedBodyWeightResult = viewModel.recommendedBodyWeight()
        }
    }

    // Save to UserDefaults to be passed to Drug Reference.
    func saveResults(crCl: Int) {
        let defaults = UserDefaults.standard
        defaults.set((sex == .male), forKey: Keys.isMale)
        defaults.set(weight, forKey: Keys.weight)
    }

    func clear() {
        textFieldIsFocused = false
        clearResult()
        // reset fields
        sex = .male
        weight = 0
        height = 0
    }

    func clearResult() {
        actualBodyWeightResult = ""
        idealBodyWeightResult = ""
        adjustedBodyWeightResult = ""
        recommendedBodyWeightResult = ""
    }

    func copy(weightType: WeightType) {
        if let viewModel = viewModel {
            switch weightType {
            case .ideal:
                if let idealBodyWeight = viewModel.rawIdealBodyWeight() {
                    copyToClipboard(idealBodyWeight)
                }
            case .adjusted:
                if let adjustedBodyWeight = viewModel.rawActualBodyWeight() {
                    copyToClipboard(adjustedBodyWeight)
                }
            case .actual:
                if let actualBodyWeight = viewModel.rawActualBodyWeight() {
                    copyToClipboard(actualBodyWeight)
                }
            case .recommended:
                if let recommendedBodyWeight = viewModel.rawRecommendedBodyWeight() {
                    copyToClipboard(recommendedBodyWeight)
                }
            }
        }
    }

    func copyToClipboard(_ s: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = s
    }
}

struct WeightCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        WeightCalculatorView()
    }
}
