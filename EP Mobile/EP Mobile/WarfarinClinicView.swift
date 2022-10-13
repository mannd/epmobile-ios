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
    @State private var showDosingAlert = false
    @State private var showDosingTable = false
    @State private var viewModel: WarfarinViewModel? = nil
    @State private var doseChange: DoseChange? = nil
    @State private var dosingTableData: DosingTableData? = nil

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
                NavigationLink(destination: UIWarfarinDosingTableView(dosingTableData: dosingTableData), isActive: $showDosingTable) { EmptyView() }
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
                    Section(header: Text("Total Weekly Dose (mg)")) {
                        TextField("Weekly Dose (mg)", value: $weeklyDose, formatter: Self.numberFormatter)
                            .focused($textFieldIsFocused)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: weeklyDose) { _ in
                                clearResult()
                            }
                    }
                    Section(header: Text("Current INR")) {
                        TextField("Current INR", value: $inr, formatter: Self.numberFormatter)
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
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .navigationBarTitle(Text("Warfarin Clinic"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { showInfo.toggle() }) {
                Image(systemName: "info.circle")
            }.sheet(isPresented: $showInfo) {
                InformationView(instructions: Warfarin.getInstructions(), references: Warfarin.getReferences(), name: "Warfarin Clinic")
            })
            .alert("Result", isPresented: $showDosingAlert, actions: {
                Button("Show Dose Table", role: .destructive, action: {
                   calculateDosingTable()
                })
                // Cancel button automatically added when we have a destructive button.
            }, message: { Text(result) })
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
            var showMessage: Bool = false
            (result, showMessage) = viewModel.calculate()
            if viewModel.weeklyDoseIsSane() && showMessage {
                dosingTableData = viewModel.dosingTableData
                showDosingAlert = true
            }
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

    func calculateDosingTable() {
        showDosingTable = true
    }

    struct UIWarfarinDosingTableView: UIViewControllerRepresentable {
        var dosingTableData: DosingTableData?
        typealias UIViewControllerType = EPSWarfarinDosingTableViewController

        func makeUIViewController(context: Context) -> EPSWarfarinDosingTableViewController {
            let sb = UIStoryboard(name: "Warfarin", bundle: nil)
            let viewController = sb.instantiateViewController(identifier: "WarfarinDosingTable") as! EPSWarfarinDosingTableViewController
            if let data = dosingTableData {
                viewController.weeklyDose = data.weeklyDose ?? 0
                viewController.lowEndPercentChange = data.lowEndDose ?? 0
                viewController.highEndPercentChange = data.highEndDose ?? 0
                viewController.tabletSize = data.tabletSize ?? 0
                viewController.increase = data.increaseDose ?? false
            }
            return viewController
        }

        func updateUIViewController(_ uiViewController: EPSWarfarinDosingTableViewController, context: Context) {

        }
    }
}

struct WarfarinCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        WarfarinClinicView()
        WarfarinClinicView.UIWarfarinDosingTableView()
    }
}
