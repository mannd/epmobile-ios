//
//  DrugDoseCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 4/26/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct DrugDoseCalculator: View {
    @State private var sex: EP_Mobile.Sex = .male
    @State private var age: Int = 0
    @State private var weight: Double = 0.0
    @State private var creatinine: Double = 0.0
    @State private var massUnit: MassUnit = .kg
    @State private var concentrationUnit: ConcentrationUnit = .mgDL
    @State private var drugDose = ""
    @State private var crClResult = ""
    @State private var showWarning = false
    @State private var showInfo = false
    @FocusState private var textFieldIsFocused: Bool

    @AppStorage(Keys.defaultMassUnit) var defaultMassUnit: String = Keys.kg
    @AppStorage(Keys.defaultConcentrationUnit) var defaultConcentrationUnit: String = Keys.mgdL

    @Binding var drugName: DrugName

    var weightLabel: String { "Weight (\(massUnit.description))" }
    var creatinineLabel: String { "Creatinine (\(concentrationUnit.description))"}

    // TODO: original drug calculator age cutoff was 18 and over?
    private static let minimumAge = 10
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
                    .roundedButton()
                }
            }
            .onChange(of: sex, perform: { _ in  clearResult() })
            .onChange(of: age, perform: { _ in  clearResult() })
            .onChange(of: weight, perform: { _ in  clearResult() })
            .onChange(of: concentrationUnit, perform: { _ in  clearResult() })
            .onChange(of: massUnit, perform: { _ in  clearResult() })
            .navigationBarTitle(Text(drugName.description), displayMode: .inline)
            .navigationBarItems(trailing: drugName != .crCl ? AnyView(Button(action: { showInfo.toggle() }) {
                Image(systemName: "info.circle")
            }.sheet(isPresented: $showInfo) {
                Info()
            }) : AnyView(EmptyView()))
        }
        .onAppear() {
            if defaultMassUnit == Keys.kg {
                massUnit = .kg
            } else {
                massUnit = .lb
            }
            if defaultConcentrationUnit == Keys.mgdL {
                concentrationUnit = .mgDL
            } else {
                concentrationUnit = .mmolL
            }
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
        } catch  {
            // TODO: original drug calculator age cutoff was 18 and over?
            if let error = error as? DoseError, error == .pediatricAge {
                crClResult = "Minimum age is 12"
            } else {
                crClResult = "INVALID ENTRY"
            }
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

private struct Info: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Caution")) {
                        Text("Do not rely on drug dose calculators unless you are fully familiar with these drugs and their dosing.  More detailed information on drug doses can be found in the Reference and Tools | Drug Reference module, which includes a creatinine clearance calculator.  \n\nAlso note that the doses calculated for the oral anticoagulant drugs are only for the treatment of non-valvular atrial fibrillation, not for other indications, such as DVT or PE.  Other factors not included in these calculators, such as pregnancy, nursing, liver dysfunction, concomitant drug use and adverse reactions can affect drug dosage.")
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
            .navigationBarTitle(Text("Drug Calculator"), displayMode: .inline)
        }
    }
}

struct DrugDoseCalculator_Previews: PreviewProvider {
    static var previews: some View {
        DrugDoseCalculator(drugName: .constant(DrugName.crCl))
        DrugDoseCalculator(drugName: .constant(DrugName.apixaban))
        Info()
    }
}
