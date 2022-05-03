//
//  QTcCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 5/2/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI
import MiniQTc

struct QTcCalculatorView: View {
    @State private var rr: Int = 0
    @State private var qt: Int = 0
    @State private var formula: Formula = .qtcBzt
    @State private var intervalRate: IntervalRateType = .interval
    @State private var result: String = ""
    @State private var maximumQTc: Double = 440.0
    @State private var flagResult = false
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
                Form {
                    Section(header: Text(intervalRateLabel())) {
                        HStack() {
                            TextField(intervalRateLabel(), value: $rr, formatter: Self.numberFormatter)
                                .focused($textFieldIsFocused)
                            Picker(selection: $intervalRate, label: Text("Interval/Rate")) {
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
                    Section(header: Text("QTc Formula")) {
                        Picker(selection: $formula, label: Text(formulaName())) {
                            Text("Bazett").tag(Formula.qtcBzt)
                            Text("Fridericia").tag(Formula.qtcFrd)
                            Text("Framingham").tag(Formula.qtcFrm)
                            Text("Hodges").tag(Formula.qtcHdg)
                        }
                    }
                    Section(header: Text("Result")) {
                        Text(result)
                            .foregroundColor(flagResult ? .red : .primary)
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
                    .frame(width: 140, height: 40)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding()
                }
            }
            .onChange(of: rr, perform: { _ in  clearResult() })
            .onChange(of: qt, perform: { _ in  clearResult() })
            .onChange(of: intervalRate, perform: { _ in  clearResult() })
            .onChange(of: formula, perform: { _ in  clearResult() })
            .navigationBarTitle(Text("QTc Calculator"), displayMode: .inline)
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
            if let maxQTc = Double(defaultMaximumQtc) {
                maximumQTc = maxQTc
            }
            if defaultIntervalOrRate == Keys.interval {
                intervalRate = .interval
            } else if defaultIntervalOrRate == Keys.rate {
                intervalRate = .rate
            }
        }
    }

    func calculate() {
        textFieldIsFocused = false
        guard qt > 0 && rr > 0 else {
            result = ErrorMessages.invalidEntry
            return
        }
        let calculator = QTc.qtcCalculator(formula: formula)
        let qtMeasurement = QtMeasurement(qt: Double(qt), intervalRate: Double(rr), units: .msec, intervalRateType: intervalRate )
        do {
            let rawResult = try calculator.calculate(qtMeasurement: qtMeasurement)
            flagResult = rawResult > maximumQTc
            result = formattedQTcResult(rawResult: rawResult)
        } catch {
            // all errors handled as invalid entry
            flagResult = false
            result = ErrorMessages.invalidEntry
        }
    }

    func formattedQTcResult(rawResult: Double) -> String {
        return "QTc = \(String(Int(round(rawResult)))) msec"
    }

    func clear() {
        textFieldIsFocused = false
        clearResult()
    }

    func clearResult() {
        flagResult = false
        result = ""
    }

    func intervalRateLabel() -> String {
        switch intervalRate {
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

struct QTcCalculator_Previews: PreviewProvider {
    static var previews: some View {
        QTcCalculatorView()
    }
}
