//
//  WarfarinCalculatorView.swift
//  EP Mobile
//
//  Created by David Mann on 5/14/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

enum TabletSize: Int, CaseIterable, Identifiable {
    case oneMG
    case twoMG
    case two_fiveMG
    case threeMG
    case fourMG
    case fiveMG
    case sixMG
    case seven_fiveMG
    case tenMG

    var id: TabletSize { self }
    var description: String {
        switch self {

        case .oneMG:
            return "1 mg"
        case .twoMG:
            return "2 mg"
        case .two_fiveMG:
            return "2.5 mg"
        case .threeMG:
            return "3 mg"
        case .fourMG:
            return "4 mg"
        case .fiveMG:
            return "5 mg"
        case .sixMG:
            return "6 mg"
        case .seven_fiveMG:
            return "7.5 mg"
        case .tenMG:
            return "10 mg"
        }
    }
    var value: Double {
        switch self {
        case .oneMG:
            return 1.0
        case .twoMG:
            return 2.0
        case .two_fiveMG:
            return 2.5
        case .threeMG:
            return 3.0
        case .fourMG:
            return 4.0
        case .fiveMG:
            return 5.0
        case .sixMG:
            return 6.0
        case .seven_fiveMG:
            return 7.5
        case .tenMG:
            return 10.0
        }
    }

}

struct WarfarinClinicView: View {
    @State private var tabletSize: TabletSize = .fiveMG
    @State private var weeklyDose: Double = 0
    @State private var inr: Double = 0
    @State private var inrTarget: InrTarget = .low
    @State private var result: String = ""
    @State private var showInfo = false
    @State private var showDosing = false
    @State private var viewModel: WarfarinViewModel? = nil

    @FocusState private var textFieldIsFocused: Bool

    @AppStorage(Keys.defaultInrTarget) var defaultInrTarget: String = Keys.lowDoseWarfarin
    @AppStorage(Keys.defaultWarfarinTablet) var defaultWarfarinTablet: String = Keys.fiveMG

    let defaultInrTargetDictionary: [String: InrTarget] = [Keys.lowDoseWarfarin: .low, Keys.highDoseWarfarin: .high]
    let defaultTabletSizeDictionary: [String: TabletSize] = [
        Keys.oneMG: .oneMG,
        Keys.twoMG: .twoMG,
        Keys.two_fiveMG: .two_fiveMG,
        Keys.threeMG: .threeMG,
        Keys.fourMG: .fourMG,
        Keys.fiveMG: .fiveMG,
        Keys.sixMG: .sixMG,
        Keys.seven_fiveMG: .seven_fiveMG,
        Keys.tenMG: .tenMG
    ]

    private static let minimum = 0.1
    private static let maximum = 500.0
    private static let range: ClosedRange<Double> = minimum...maximum
    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 1
        formatter.minimum = minimum as NSNumber
        formatter.maximum = maximum as NSNumber
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Tablet Size")) {
                        Picker(selection: $tabletSize, label: Text("Tablet size")) {
                            ForEach(TabletSize.allCases) {
                                tabletSize in Text(tabletSize.description)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: tabletSize) { _ in
                            clearResult()
                        }
                    }
                    Section(header: Text("Weekly Dose (mg)")) {
                        TextField("Weekly Dose", value: $weeklyDose, formatter: Self.numberFormatter)                            .keyboardType(.numberPad)
                            .focused($textFieldIsFocused)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: weeklyDose) { _ in
                                clearResult()
                            }
                    }
                    Section(header: Text("Current INR")) {
                        TextField("Current INR", value: $inr, formatter: Self.numberFormatter)                            .keyboardType(.numberPad)
                            .focused($textFieldIsFocused)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: inr) { _ in
                                clearResult()
                            }
                    }
                    Section(header: Text("INR Target")) {
                        Picker(selection: $inrTarget, label: Text("INR Target")) {
                            ForEach(InrTarget.allCases) {
                                inrTarget in Text(inrTarget.description)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: inrTarget) { _ in
                            clearResult()
                        }
                    }
                    Section(header: Text("Result")) {
                        Text(result)
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
            .navigationBarTitle(Text("Warfarin Clinic"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { showInfo.toggle() }) {
                Image(systemName: "info.circle")
            }.sheet(isPresented: $showInfo) {
                Info()
            })
            .alert(isPresented: $showDosing) {
                Alert(
                    title: Text("Result"),
                    message: Text(result),
                    primaryButton: .destructive(
                        Text("Show Dose Table"),
                        action: { showDoseTable() }
                    ),
                    secondaryButton: .default(
                        Text("Cancel"),
                        action: { }
                    )
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            inrTarget = defaultInrTargetDictionary[defaultInrTarget] ?? .low
            tabletSize = defaultTabletSizeDictionary[defaultWarfarinTablet] ?? .fiveMG
        }
    }

    func calculate() {
        textFieldIsFocused = false
        viewModel = WarfarinViewModel(tabletSize: tabletSize.value, weeklyDose: weeklyDose, inr: inr, inrTarget: inrTarget)
        if let viewModel = viewModel {
            result = viewModel.calculate()
            showDosing = viewModel.showDoseTable()
        }
    }

    func clear() {
        textFieldIsFocused = false
        weeklyDose = 0
        inr = 0
        clearResult()
    }

    func clearResult() {
        result = ""
    }

    func showDoseTable() {

    }
}

private struct Info: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Usage")) {
                        Text("This calculator can be used to adjust the warfarin dose when a patient is on a stable weekly dosing schedule. It should not be used when first starting warfarin. Select the tablet size the patient uses and the target INR.  Enter the measured INR and the total number of mg the patient is taking per week (e.g. a patient taking 5 mg daily takes 5 x 7 = 35 mg of warfarin per week).  The calculator will determine the percentage weekly dose increase or decrease that is likely to bring the INR back into the target range.  When it is feasible, the calculator will suggest the number of tablets to take each day of the week to achieve the INR goal. An upper and lower range of dosing will be given; in some cases, when dosing changes are small, the upper and lower range will be identical. When there is a range of doses, you might decide to use the higher or lower dose depending on other factors, such as the patient\'s previous response to dosing changes or the patient\'s age.  Warfarin dosing is not an exact science!")
                    }
                    Section(header: Text("Reference")) {
                        Text("Reference: Horton J, Bushwick B: American Family Physician. Feb 1, 1999. https://www.aafp.org/afp/1999/0201/p635.html")
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
            .navigationBarTitle(Text("Warfarin Clinic"), displayMode: .inline)
        }
    }
}

struct WarfarinCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        WarfarinClinicView()
        Info()
    }
}
