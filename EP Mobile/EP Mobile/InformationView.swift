//
//  InformationView.swift
//  EP Mobile
//
//  Created by David Mann on 10/6/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

/// Display information like instructions, keys, references, and optional sections.
/// Optional sections are always first in the view.
struct InformationView: View {
    @Environment(\.dismiss) private var dismiss
    var instructions: String?
    var key: String?
    var references: [Reference]
    var name: String
    var optionalSectionTitle: String?
    var optionalSectionText: String?
    var instructionsTitle: String = "Instructions"
    var keyTitle: String = "Key"

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    if let optionalSectionTitle, let optionalSectionText {
                        Section(header: Text(optionalSectionTitle)){
                            Text(optionalSectionText)
                        }
                    }
                    if let instructions = instructions {
                        Section(header: Text(instructionsTitle)) {
                            Text(instructions)
                        }
                    }
                    if let key = key {
                        Section(header: Text(keyTitle)) {
                            Text(key)
                        }
                    }
                    if references.count > 0 {
                        Section(header: Text(references.count > 1 ? "References" : "Reference")) {
                            ForEach (0..<references.count, id: \.self) { i in
                                Text(LocalizedStringKey(references[i].getReferenceWithMarkdownLink() ?? "Missing ref"))
                            }
                        }
                    }
                }
                Button("Done") {
                    dismiss()
                }
                .roundedButton()
            }
            .navigationBarTitle(Text(name), displayMode: .inline)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(references: [Reference("Test Reference\ndoi://www.google.com")], name: "Test Title")
        InformationView(instructions: "Test instructions", key: "Test key", references: [Reference("Test Reference\nhttps://www.google.com")], name: "Test Title")
        InformationView(references: [Reference("Test Reference\nhttps://www.google.com")], name: "Test Title", optionalSectionTitle: "Special Notes", optionalSectionText: "Here are some special notes.")
    }
}
