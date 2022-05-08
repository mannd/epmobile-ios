//
//  QTcIvcdCalculatorView.swift
//  EP Mobile
//
//  Created by David Mann on 5/7/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI
import MiniQTc

struct QTcIvcdCalculatorView: View {
    @State private var intervalRate: Int = 0
    @State private var qt: Int = 0
    @State private var qrs: Int = 0
    @State private var formula: Formula = .qtcBzt
    @State private var intervalRateType: IntervalRateType = .interval
    @State private var result: QTcIvcdResult = QTcIvcdResult()
    @State private var isLbbb: Bool = false
    @State private var sex: EP_Mobile.Sex = .male
    @State private var errorMessage = ""
    @State private var showErrorMessage = false
    @State private var showResults = false
    @FocusState private var textFieldIsFocused: Bool

    @AppStorage(Keys.defaultQtcFormula) var defaultQtcFormula: String = Keys.bazett
    @AppStorage(Keys.intervalOrRate) var defaultIntervalOrRate: String = Keys.interval
    @AppStorage(Keys.maximumQtc) var defaultMaximumQtc: String = Keys.qtc440

    private static let minimumValue = 0
    private static let maximumValue = 6000
    private static let valueRange: ClosedRange<Int> = minimumValue...maximumValue
    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.minimum = minimumValue as NSNumber
        formatter.maximum = maximumValue as NSNumber
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: QTcIvcdResultView(qtcIvcdResult: $result), isActive: $showResults) { EmptyView() }
                Form {
                    Section(header: Text(intervalRateLabel())) {
                        HStack() {
                            TextField(intervalRateLabel(), value: $intervalRate, formatter: Self.numberFormatter)
                                .focused($textFieldIsFocused)
                            Picker(selection: $intervalRateType, label: Text("Interval/Rate")) {
                                Text("Interval").tag(IntervalRateType.interval)
                                Text("Heart rate").tag(IntervalRateType.rate)
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    Section(header: Text("QT interval (msec)")) {
                        TextField("QT interval (msec)", value: $qt, formatter: Self.numberFormatter)
                            .focused($textFieldIsFocused)
                    }
                    Section(header: Text("QRS (msec)")) {
                        TextField("QRS interval (msec)", value: $qrs, formatter: Self.numberFormatter)
                            .focused($textFieldIsFocused)
                    }
                    Section(header: Text("LBBB")) {
                        Toggle(isOn: $isLbbb) {
                            Text("LBBB?")
                        }

                    }
                    Section(header: Text("Sex")) {
                        Picker(selection: $sex, label: Text("")) {
                            Text("Male").tag(EP_Mobile.Sex.male)
                            Text("Female").tag(EP_Mobile.Sex.female)
                        }.pickerStyle(.segmented)
                    }
                    Section(header: Text("QTc Formula")) {
                        Picker(selection: $formula, label: Text(formulaName())) {
                            Text("Bazett").tag(Formula.qtcBzt)
                            Text("Fridericia").tag(Formula.qtcFrd)
                            Text("Framingham").tag(Formula.qtcFrm)
                            Text("Hodges").tag(Formula.qtcHdg)
                        }
                    }
                }
                HStack {
                    Group {
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
            .navigationBarTitle(Text("QTc IVCD Calculator"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            if defaultQtcFormula == Keys.bazett {
                formula = .qtcBzt
            } else if defaultQtcFormula == Keys.fridericia {
                formula = .qtcFrd
            } else if defaultQtcFormula == Keys.framingham {
                formula = .qtcFrm
            } else if defaultQtcFormula == Keys.hodges {
                formula = .qtcHdg
            }
            if defaultIntervalOrRate == Keys.interval {
                intervalRateType = .interval
            } else if defaultIntervalOrRate == Keys.rate {
                intervalRateType = .rate
            }
        }
        .alert(isPresented: $showErrorMessage) {
                   Alert(
                       title: Text("Input Error"),
                       message: Text(errorMessage)
                   )
               }
    }

    func calculate() {
        textFieldIsFocused = false
        showErrorMessage = false
        let qtIvcdViewModel = QTcIvcdViewModel(qt: Double(qt), qrs: Double(qrs), intervalRate: Double(intervalRate), intervalRateType: intervalRateType, sex: sex, formula: formula, isLBBB: isLbbb)
        do {
            let result = try qtIvcdViewModel.calculate()
            showResults = true
        } catch {
            if let error = error as? QTcIvcdError {
                switch error {
                case .tooShortQRS:
                    errorMessage = ErrorMessage.shortQrsError
                case .invalidParameter:
                    errorMessage = ErrorMessage.inputError
                case .longQRS:
                    errorMessage = ErrorMessage.longQrsError
                }
            } else {
                errorMessage = ErrorMessage.calculationError
            }
            showErrorMessage = true
        }
    }

    func clear() {
        textFieldIsFocused = false
        qt = 0
        qrs = 0
        intervalRate = 0
        isLbbb = false
    }

    func intervalRateLabel() -> String {
        switch intervalRateType {
        case .rate:
            return "Heart rate (bpm)"
        case .interval:
            return "RR Interval (msec)"
        }
    }

    func formulaName() -> String {
        let calculator = QTc.qtcCalculator(formula: formula)
        return calculator.longName
    }
}

struct QTcIvcdCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        QTcIvcdCalculatorView()
    }
}
