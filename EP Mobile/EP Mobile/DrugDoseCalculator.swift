//
//  DrugDoseCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 4/26/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct DrugDoseCalculator: View {
    @State private var sex: Sex = .male
    @State private var age: Int = 0
    @State private var weight: Double = 0.0
    @State private var creatinine: Double = 0.0
    @State private var massUnit: MassUnit = defaultMassUnit
    @State private var concentrationUnit: ConcentrationUnit = defaultConcentrationUnit
    @State private var drugDose = ""
    @State private var crClResult = ""
    @State private var showWarning = false
    @FocusState private var textFieldIsFocused: Bool

    @Binding var drugName: DrugName

    var weightLabel: String { "Weight (\(massUnit.description))" }
    var creatinineLabel: String { "Creatine (\(concentrationUnit.description))"}

    private static let defaultMassUnit: MassUnit = {
        let unit = UserDefaults.standard.string(forKey: "defaultweightunit")
        if unit == "lb" {
            return MassUnit.lb
        } else {
            return MassUnit.kg
        }
    }()
    private static let defaultConcentrationUnit: ConcentrationUnit = {
        let unit = UserDefaults.standard.string(forKey: "defaultcreatinineunit")
        if unit == "mg" {
            return ConcentrationUnit.mgDL
        } else {
            return ConcentrationUnit.mmolL
        }
    }()

    private static let minimumAge = 16
    private static let maximumAge = 120
    private static let ageRange: ClosedRange<Int> = minimumAge...maximumAge
    private static var ageNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.minimum = minimumAge as NSNumber
        formatter.maximum = maximumAge as NSNumber
        return formatter
    }()
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
    // Some reasonable maximums
    // Highest recorded creatinine was 73.8 mg/dL
    // See https://dx.doi.org/10.1155%2F2021%2F6048919
    // This calculator (http://www.scymed.com/en/smnxps/psxdf212_c.htm) has
    // max creatinine of 50 mg/dL and 4421 µmol/L.
    private static let minimumCreatinine = 0.1
    private static let maximumCreatinine = 4421.0
    private static let creatinineRange: ClosedRange<Double> = minimumCreatinine...maximumCreatinine
    private static var creatinineNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimum = minimumCreatinine as NSNumber
        formatter.maximum = maximumCreatinine as NSNumber
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
                    Section(header: Text("Age (yrs)")) {
                        HStack {
                            TextField("Age (yrs)", value: $age, formatter: Self.ageNumberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .focused($textFieldIsFocused)
                        }

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
                    Section(header: Text(creatinineLabel)) {
                        HStack {
                            TextField(creatinineLabel, value: $creatinine, formatter: Self.creatinineNumberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .focused($textFieldIsFocused)
                            Picker(selection: $concentrationUnit, label: Text("Units")) {
                                ForEach(ConcentrationUnit.allCases) {
                                    unit in Text(unit.description)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    Section(header: Text("Creatinine Clearance")) {
                        Text(crClResult)
                    }
                    if drugName != .crCl {
                        Section(header: Text("Drug Dose")) {
                            Text(drugDose)
                        }
                    }
                }
                HStack() {
                    Group() {
                        Button("Calculate") {
                            calculate()
                        }
                        Button("Clear") {
                            clear()
                        }
                    }
                    .frame(width: 140, height: 40)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding()
                }
            }
            .onChange(of: sex, perform: { _ in  clearResult() })
            .onChange(of: age, perform: { _ in  clearResult() })
            .onChange(of: weight, perform: { _ in  clearResult() })
            .navigationBarTitle(Text(drugName.description), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showWarning) {
                   Alert(
                       title: Text("Warning"),
                       message: Text(drugDose)
                   )
               }
    }

    func getCrStep() -> Double {
        switch concentrationUnit {
        case .mgDL:
            return 0.1
        case .mmolL:
            return 1.0
        }
    }

    func calculate() {
        textFieldIsFocused = false
        do {
            let patient = try Patient(age: age, sex: sex, weight: weight, massUnits: massUnit, creatinine: creatinine, concentrationUnits: concentrationUnit)
            crClResult = patient.crClResult(concentrationUnit: concentrationUnit)
            // handle drugs
            if let drug = DrugFactory.create(drugName: drugName, patient: patient) {
                drugDose = drug.getDose()
                showWarning = drug.hasWarning()
            }
            saveResults(crCl: Int(round(patient.crCl)))
        } catch {
            crClResult = "INVALID RESULT"
        }
    }

    // Save to UserDefaults to be passed to Drug Reference.
    func saveResults(crCl: Int) {
        let defaults = UserDefaults.standard
        defaults.set(age, forKey: Keys.age)
        defaults.set((sex == .male), forKey: Keys.isMale)
        defaults.set(weight, forKey: Keys.weight)
        defaults.set(creatinine, forKey: Keys.creatinine)
        defaults.set(crCl, forKey: Keys.creatinineClearance)
    }

    func clear() {
        textFieldIsFocused = false
        clearResult()
        // reset fields
        age = 0
        sex = .male
        weight = 0
        creatinine = 0
//        massUnit = Self.defaultMassUnit
//        concentrationUnit = Self.defaultConcentrationUnit
    }

    func clearResult() {
        crClResult = ""
        drugDose = ""
    }

    func convertWeight() {
        print("convert weight")
        switch massUnit {
        case .kg:
            weight = MassUnit.lbToKg(weight)
        case .lb:
            weight = MassUnit.kgToLb(weight)
        }
    }
}

struct DrugDoseCalculator_Previews: PreviewProvider {
    static var previews: some View {
        DrugDoseCalculator(drugName: .constant(DrugName.crCl))
    }
}
