//
//  EntrainmentCalculatorView.swift
//  EP Mobile
//
//  Created by David Mann on 5/19/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct EntrainmentCalculatorView: View {
    @State private var tcl: Double = 0
    @State private var ppi: Double = 0
    @State private var concealedFusion: Bool = false
    @State private var sQrs: Double = 0
    @State private var egQrs: Double = 0
    @State private var result = ""
    @State private var showingInfo = false
    @FocusState private var textFieldIsFocused: Bool

    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.minimum = NSNumber(value: 0)
        formatter.maximum = NSNumber(value: 1000)
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Tachycardia CL and PPI")) {
                        HStack {
                            Text("Tachycardia CL")
                            TextField("TCL (msec)", value: $tcl, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("Post-pacing interval")
                            TextField("PPI (msec)", value: $ppi, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                    }
                    Section(header: Text("Concealed fusion")) {
                        Toggle(isOn: $concealedFusion) {
                            Text("Concealed fusion")
                        }
                        HStack {
                            Text("Stim-QRS")
                                .foregroundColor(concealedFusion ? .primary : Color.secondary)
                            TextField("S-QRS (msec)", value: $sQrs, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        .disabled(!concealedFusion)
                        HStack {
                            Text("EG-QRS")
                                .foregroundColor(concealedFusion ? .primary : Color.secondary)
                            TextField("EG-QRS (msec)", value: $egQrs, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        .disabled(!concealedFusion)
                    }
                    Section(header: Text("Result")) {
                        Text(result)
                    }
                }
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: tcl, perform: { _ in clearResult() })
            .onChange(of: ppi, perform: { _ in clearResult() })
            .onChange(of: concealedFusion, perform: { _ in
                textFieldIsFocused = false
                clearResult()
                sQrs = 0
                egQrs = 0
            })
            .onChange(of: sQrs, perform: { _ in clearResult() })
            .onChange(of: egQrs, perform: { _ in clearResult() })
            .navigationBarTitle(Text("Entrainment Map"), displayMode: .inline)
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
        textFieldIsFocused = false
        print("sQrs", sQrs as Any)
        print("egQrs", egQrs as Any)
        let allowedSQrs = concealedFusion ? sQrs : nil
        let allowedEgQrs = concealedFusion ? egQrs : nil
        let viewModel = EntrainmentViewModel(tcl: tcl, ppi: ppi, concealedFusion: concealedFusion, sQrs: allowedSQrs, egQrs: allowedEgQrs)
        result = viewModel.calculate()
    }

    func clear() {
        textFieldIsFocused = false
        tcl = 0
        ppi = 0
        concealedFusion = false
        sQrs = 0
        egQrs = 0
        clearResult()
    }

    func clearResult() {
        result = ""
    }
}

private struct Info: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("How to Use")) {
                        Text("This Entrainment Mapping module is most suited for mapping ischemic ventricular tachycardia (VT), but principles of entrainment apply to all reentrant arrhythmias.\n\nEntrainment is performed by pacing during stable VT (or other reentrant tachycardia) for approximately 8-15 beat trains at 20-40 msec shorter than the tachycardia cycle length (TCL).  Make sure all electrograms are 'entrained', i.e. the CL shortens to the pacing CL.\n\nThe post-pacing interval (PPI) is measured from the last pacing stimulus to the next electrogram recorded from the pacing site.  Concealed fusion is present if the tachycardia morphology does not change during entrainment.  If there is concealed fusion then the pacing site is in an area of slow conduction near the critical isthmus of the reentry circuit.\n\nDuring VT if a discrete electrogram (EG) is present prior to the QRS onset then the EG-QRS interval can be measured.  During entrainment with concealed fusion, if there is a delay between the pacing stimulus to onset of the QRS (S-QRS), then the site is within the critical isthmus if the S-QRS interval is similar to the EG-QRS interval.  In addition the relative location within the critical isthmus can be estimated by the ratio of the S-QRS to the TCL.  Sites with concealed fusion but long PPI intervals are probably adjacent bystander tracts.\n\nPacing sites within the critical isthmus are associated with a much higher chance of successful tachycardia termination with ablation than other sites.\n\nEP Mobile uses the criteria of El-Shalakany et al. to identify VT sites with high likelihood of ablation success.")
                    }
                    Section(header: Text("References")) {
                        Text("Stevenson WG et al. JACC 1997;29:1180.\nhttp://content.onlinejacc.org/article.aspx?articleid=1121699\nEl-Shalakany A et al. Circulation 1999;99:2283.\n https://doi.org/10.1161/01.cir.99.17.2283")
                    }
                }
                Button("Done") {
                    dismiss()
                }
                .roundedButton()
            }
            .navigationBarTitle(Text("Entrainment Map"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

struct EntrainmentCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        EntrainmentCalculatorView()
        Info()
    }
}
