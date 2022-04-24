//
//  DateCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 4/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct DateCalculator: View {
    @State private var startingDate: Date = Date()
    @State private var numberOfDays = 90
    @State private var subtractDays = false
    @State private var result = ""

    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 365
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Starting date")) {

                        DatePicker(selection: $startingDate, displayedComponents: [.date], label: { Text("Starting date") })

                    }
                    Section(header: Text("Number of days")) {
                        HStack {
                            TextField("", value: $numberOfDays         , formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                            Stepper("", value: $numberOfDays, in: 1...365, step: 1).labelsHidden()
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
            .navigationBarTitle(Text("Date Calculator"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        result = DateMath.addDays(startingDate: startingDate, days: numberOfDays, subtractDays: subtractDays)
    }

    func clear() {
        result = ""
    }
}

struct DateCalculator_Previews: PreviewProvider {
    static var previews: some View {
        DateCalculator()
    }
}
