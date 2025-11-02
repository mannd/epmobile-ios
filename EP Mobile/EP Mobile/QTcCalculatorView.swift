//
//  QTcCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 5/2/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI
import MiniQTc

fileprivate let calculatorName = "QTc Calculator"

extension QTcCalculator: InformationProvider {
    static func getReferences() -> [Reference] {
        var references: [Reference] = []
        references.append(Reference(QTc.qtcCalculator(formula: .qtcBzt).reference))
        references.append(Reference(QTc.qtcCalculator(formula: .qtcFrd).reference))
        references.append(Reference(QTc.qtcCalculator(formula: .qtcFrm).reference))
        references.append(Reference(QTc.qtcCalculator(formula: .qtcHdg).reference))
        references.append(Reference("Rautaharju PM, Surawicz B, Gettes LS. AHA/ACCF/HRS Recommendations for the Standardization and Interpretation of the Electrocardiogram Part IV: The ST Segment, T and U Waves, and the QT Interval: A Scientific Statement From the American Heart Association Electrocardiography and Arrhythmias Committee, Council on Clinical Cardiology; the American College of Cardiology Foundation; and the Heart Rhythm Society: Endorsed by the International Society for Computerized Electrocardiology. Circulation. 2009;119(10):e241-e250.\ndoi:10.1161/CIRCULATIONAHA.108.191096"))
        return references
    }

    static func getInstructions() -> String? {
        nil
    }

    static func getKey() -> String? {
        nil
    }
}

struct QTcCalculatorView: View {
    @State private var intervalRate: Int = 0
    @State private var qt: Int = 0
    @State private var formula: Formula = .qtcBzt
    @State private var intervalRateType: IntervalRateType = .interval
    @State private var result: String = ""
    @State private var maximumQTc: Double = 440.0
    @State private var flagResult = false
    @State private var showInfo = false
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
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text(intervalRateLabel())) {
                        HStack() {
                            TextField(intervalRateLabel(), value: $intervalRate, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
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
                            .keyboardType(.numbersAndPunctuation)
                            .focused($textFieldIsFocused)
                    }
                    Section(header: Text("QTc Formula")) {
                        Picker(selection: $formula, label: Text(formulaName())) {
                            Text("Hodges").tag(Formula.qtcHdg)
                            Text("Framingham").tag(Formula.qtcFrm)
                            Text("Fridericia").tag(Formula.qtcFrd)
                            Text("Bazett").tag(Formula.qtcBzt)
                        }
                        .pickerStyle(.menu)
                    }
                    Section(header: Text("Result")) {
                        Text(result)
                            .foregroundColor(flagResult ? .red : .primary)
                    }
                }
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: intervalRate, perform: { _ in  clearResult() })
            .onChange(of: qt, perform: { _ in  clearResult() })
            .onChange(of: intervalRateType, perform: { _ in  clearResult() })
            .onChange(of: formula, perform: { _ in  clearResult() })
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
                InformationView(references: QTcCalculator.getReferences(), name: calculatorName)
            }

//                .sheet(isPresented: $showInfo) {
//                InformationView(references: QTcCalculator.getReferences(), name: calculatorName)
//            }
        }
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
                intervalRateType = .interval
            } else if defaultIntervalOrRate == Keys.rate {
                intervalRateType = .rate
            }
        }
    }

    func calculate() {
        textFieldIsFocused = false
        let qtMeasurement = QtMeasurement(qt: Double(qt), intervalRate: Double(intervalRate), units: .msec, intervalRateType: intervalRateType )
        let calculatorViewModel = QTcCalculatorViewModel(qtMeasurement: qtMeasurement, formula: formula, maximumQTc: maximumQTc)
       (result, flagResult) = calculatorViewModel.calculate()
    }

    func clear() {
        textFieldIsFocused = false
        qt = 0
        intervalRate = 0
        clearResult()
    }

    func clearResult() {
        flagResult = false
        result = ""
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

struct QTcCalculator_Previews: PreviewProvider {
    static var previews: some View {
        QTcCalculatorView()
    }
}
