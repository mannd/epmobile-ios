//
//  BmiCalculatorView.swift
//  EP Mobile
//
//  Created by David Mann on 5/3/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import SwiftUI

fileprivate let calculatorName = "BMI Calculator"

struct BmiCalculatorView: View {
    @State private var weight: Double = 0.0
    @State private var height: Double = 0.0
    @State private var massUnit: MassUnit = .kg
    @State private var heightUnit: HeightUnit = .cm
    @State private var showInfo = false
    @State private var bmiResult: String = ""
    @State private var bmiClassificationResult: String = ""
    @State private var viewModel: WeightCalculatorViewModel? = nil
    @State private var model: BmiModel? = nil
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
        NavigationStack {
            VStack {
                // Using Form here gives a warning message about ambiguous constraints.
                // This is avoided by using List, but this seems to be an Apple bug
                // related to the embedded DatePicker.
                Form() {
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
                    Section(header: Text("BMI (mg/kg²)")) {
                        HStack {
                            Text(bmiResult)
                            Spacer()
                            Button("Copy") {
                                copyBmi()
                            }
                        }
                    }
                    Section(header: Text("Classification")) {
                        HStack {
                            Text(bmiClassificationResult)
                            Spacer()
                            Button("Copy") {
                                copyBmiClassification()
                            }
                        }
                    }
                }
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: weight, perform: { _ in  clearResult() })
            .onChange(of: height, perform: { _ in  clearResult() })
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
                InformationView(instructions: BmiModel.getInstructions(), key: BmiModel.getKey(), references: BmiModel.getReferences(), name: calculatorName)
            }
        }
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
        model = try? BmiModel(height: heightMeasurement, weight: weightMeasurement)
        if let model = model {
            bmiResult = model.calculateRounded() + " mg/kg²"
            bmiClassificationResult = BmiModel.getClassification(bmi: BmiModel.roundToTenths(model.calculate())).description
        } else {
            bmiResult = "ERROR"
            bmiClassificationResult = "ERROR"
            
        }
    }

    func clear() {
        textFieldIsFocused = false
        clearResult()
        // reset fields
        weight = 0
        height = 0
    }

    func clearResult() {
        bmiResult = ""
        bmiClassificationResult = ""
    }

    func copyBmi() {
        copyToClipboard(bmiResult)
    }

    func copyBmiClassification() {
        copyToClipboard(bmiClassificationResult)
    }

    private func copyToClipboard(_ s: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = s
    }
}

struct BmiCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        BmiCalculatorView()
    }
}

