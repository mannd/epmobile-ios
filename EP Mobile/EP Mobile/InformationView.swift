//
//  InformationView.swift
//  EP Mobile
//
//  Created by David Mann on 10/6/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) private var dismiss
    var instructions: String?
    var key: String?
    var reference: String
    var name: String = "TITLE"
    var multipleReferences = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    if let instructions = instructions {
                        Section(header: Text("Instructions")) {
                            Text(instructions)
                        }
                    }
                    if let key = key {
                        Section(header: Text("Key")) {
                            Text(key)
                        }
                    }
                    // Note that hyperlinks don't appear when Text is used with a variable, unless you do this...
                    Section(header: Text(multipleReferences ? "References" : "Reference")) {
                        Text(LocalizedStringKey(reference))
                    }
                }
                Button("Done") {
                    dismiss()
                }
                .frame(width: 140, height: 40)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(15)
                .padding()
            }
            .navigationBarTitle(Text(name), displayMode: .inline)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(reference: "Test Reference\nhttps://www.google.com")
    }
}
