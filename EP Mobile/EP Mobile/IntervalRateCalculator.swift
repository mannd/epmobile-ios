//
//  IntervalRateCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 4/23/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

enum ConversionType: Int, CaseIterable, Identifiable {
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
    @State private var value = 0
    @State private var result = ""
    @State private var conversionType: ConversionType = .intervalToRate
    @FocusState private var textFieldIsFocused: Bool

    private static let minimumValue = 5
    private static let maximumValue = 6000
    private static let valueRange: ClosedRange<Int> = minimumValue...maximumValue
    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.minimum = minimumValue as NSNumber
        formatter.maximum = maximumValue as NSNumber
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
                            Text(valueLabel())
                            TextField(valueLabel(), value: $value, formatter: Self.numberFormatter)                            .keyboardType(.numberPad)
                                .focused($textFieldIsFocused)
                                .multilineTextAlignment(.trailing)

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
        textFieldIsFocused = false
        guard value > 0 else {
            result = "INVALID ENTRY"
            return
        }
        if let convertedValue = IntervalRateConversion.convert(value: value) {
            switch conversionType {
            case .intervalToRate:
                result = "Rate is \(convertedValue) bpm"
            case .rateToInterval:
                result = "Interval is \(convertedValue) msec"
            }
        }
    }

    func clear() {
        textFieldIsFocused = false
        value = 0
        clearResult()
    }

    func clearResult() {
        result = ""
    }

    func valueLabel() -> String {
        switch conversionType {
        case .intervalToRate:
            return "Interval in msec"
        case .rateToInterval:
            return "Rate in bpm"
        }
    }
}



struct IntervalRateCalculator_Previews: PreviewProvider {
    static var previews: some View {
        IntervalRateCalculator()
    }
}
