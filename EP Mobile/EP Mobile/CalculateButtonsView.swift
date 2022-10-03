//
//  CalculateButtonsView.swift
//  EP Mobile
//
//  Created by David Mann on 10/2/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct CalculateButtonsView: View {
    var calculate: () -> Void
    var clear: () -> Void
    var body: some View {
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
}

struct CalculateButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateButtonsView(calculate: {}, clear: {})
    }
}
