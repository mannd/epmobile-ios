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
        VStack(alignment: .leading) {
            Toggle(isOn: $parameter) {
                Text(label)
            }
            Text(description).font(.subheadline).fontWeight(.light)
        }
    }
}

struct DescriptionView: View {
    var description: String
    var body: some View {
        Text(description).font(.subheadline).fontWeight(.light)
    }

    init(_ description: String) {
        self.description = description
    }
}
