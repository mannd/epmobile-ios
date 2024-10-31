//
//  ToggleView.swift
//  EP Mobile
//
//  Created by David Mann on 10/31/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//


import SwiftUI

struct ToggleView: View {
    @Binding var parameter: Bool
    var label: String
    var description: String

    var body: some View {
        Toggle(isOn: $parameter) {
                Text(label)
                Text(description).font(.caption)
        }
    }
}
