//
//  DateInfoView.swift
//  EP Mobile
//
//  Created by David Mann on 10/3/26.
//  Copyright © 2026 EP Studios. All rights reserved.
//

import SwiftUI

// DateCalculator has a customized information view.
struct DateInfoView: View {
    fileprivate let calculatorName = "Date Calculator"

    var body: some View {
        Form {
            Section(header: Text("Instructions")) {
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
        .navigationTitle(calculatorName + " Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}
