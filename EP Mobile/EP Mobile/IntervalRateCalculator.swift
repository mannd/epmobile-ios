//
//  IntervalRateCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 4/23/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

enum ConversionType: Int, CaseIterable, Identifiable, Equatable {
    case intervalToRate
    case rateToInterval

    var id: ConversionType { self }
    var description: String {
        switch self {
        case .intervalToRate:
            return "Interval ► Rate"
        case .rateToInterval:
            return "Rate ► Interval"
        }
    }
}

struct IntervalRateCalculator: View {
    @State private var value = 600
    @State private var result = ""
    @State private var conversionType: ConversionType = .intervalToRate

    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 10
        formatter.maximum = 2000
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Type of conversion")) {
                        Picker(selection: $conversionType, label: Text("Interval/Rate")) {
                            ForEach(ConversionType.allCases) {
                                conversionType in Text(conversionType.description)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: conversionType) { _ in
                            clearResult()
                        }
                    }
                    Section(header: Text(valueLabel())) {
                        HStack {
                            TextField(valueLabel(), value: $value, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                            Stepper("", value: $value, in: 10...2000, step: 1).labelsHidden()
                        }
                        .onChange(of: value) { _ in
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
                    .frame(width: 140, height: 40)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding()
                }
            }
            .navigationBarTitle(Text(conversionType.description), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        guard value > 0 else {
            result = "INVALID ENTRY"
            return
        }
        let convertedValue = convertValue(value: value)
        switch conversionType {
        case .intervalToRate:
            result = "Rate is \(convertedValue) bpm"
        case .rateToInterval:
            result = "Interval is \(convertedValue) msec"
        }
    }

    private func convertValue(value: Int) -> String {
        guard value > 0 else { return "ERROR" }
        return String(Int(round(60_000.0 / Double(value))))
    }

    func clear() {
        switch conversionType {
        case .intervalToRate:
            value = 600
        case .rateToInterval:
            value = 100
        }
        clearResult()
    }

    func clearResult() {
        result = ""
    }

    func valueLabel() -> String {
        switch conversionType {
        case .intervalToRate:
            return "interval in msec"
        case .rateToInterval:
            return "rate in bpm"
        }
    }
}



struct IntervalRateCalculator_Previews: PreviewProvider {
    static var previews: some View {
        IntervalRateCalculator()
    }
}
