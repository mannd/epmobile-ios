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
    @State private var showingInfo = false

    private static let minimumDays = 1
    private static let maximumDays = 1000
    private static let dayRange: ClosedRange<Int> = minimumDays...maximumDays

    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = minimumDays as NSNumber
        formatter.maximum = maximumDays as NSNumber
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                // Using Form here gives a warning message about ambiguous constraints.
                // This is avoided by using List, but this seems to be an Apple bug
                // related to the embedded DatePicker.
                Form() {
                    Section(header: Text("Starting date")) {
                        DatePicker(selection: $startingDate, displayedComponents: [.date], label: { Text("Starting date") })
                    }
                    Section(header: Text("Number of days")) {
                        HStack {
                            TextField("", value: $numberOfDays         , formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                            Stepper("", value: $numberOfDays, in: Self.dayRange, step: 1).labelsHidden()
                        }
                    }
                    Section(header: Text("Subtract days")) {
                        Toggle(isOn: $subtractDays) {
                            Text("Subtract days")
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
            .onChange(of: numberOfDays, perform: { _ in clearResult() })
            .onChange(of: startingDate, perform: { _ in clearResult() })
            .onChange(of: subtractDays, perform: { _ in clearResult() })
            .navigationBarTitle(Text("Date Calculator"), displayMode: .inline)
            // TODO change destination to the Note you want to show.
            .navigationBarItems(trailing:
                                    Button(action: { showingInfo.toggle() }) {
                Image(systemName: "info.circle")
            }).sheet(isPresented: $showingInfo) {
                Info()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        result = DateMath.addDays(startingDate: startingDate, days: numberOfDays, subtractDays: subtractDays)
    }

    func clear() {
        startingDate = Date()
        numberOfDays = 90
        subtractDays = false
        clearResult()
    }

    func clearResult() {
        result = ""
    }
}

private struct Info: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("How to Use")) {
                        Text("Use this calculator to do date arithmetic.").bold()
                        Text("Set the starting date to the index date (such as today) and then enter the number of days in the future or past that you are adding or subtracting.  Turn ") + Text("Subtract days").bold() + Text(" on to subtract days from the index date.")
                    }
                    Section(header: Text("Examples")) {
                        Text("90 Days").bold()
                        Text("The number of days after revascularization (e.g. stent or CAGB) before ICD can be implanted.  Note the CMS NCD states 3 months, but this can vary between 90 and 92 days, so 90 days is often quoted as the number of days to wait.  Similarly the guidelines state waiting 90 days after diagnosis of non-ischemic cardiomyopathy before ICD implantation.")
                        Text("40 Days").bold()
                             Text("The number of days to wait after acute myocardial infarction before ICD implantation.")
                        Text("30 Days").bold()
                        Text("The number of days an H&P is valid prior to a procedure.")
                    }
                }
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 140, height: 40)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(15)
                .padding()
            }
            .navigationBarTitle(Text("Date Calculator"), displayMode: .inline)
        }
    }

}

struct DateCalculator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DateCalculator()
            Info()
            Info()
        }
    }
}
