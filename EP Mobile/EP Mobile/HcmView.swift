//
//  HcmView.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct HcmView: View {
    @State private var age: Double = 0
    @State private var thickness: Double = 0
    @State private var laDiameter: Double = 0
    @State private var gradient: Double = 0
    @State private var familyHxScd: Bool = false
    @State private var hxNsvt: Bool = false
    @State private var hxSyncope: Bool = false
    @State private var result: String = ""
    @State private var detailedResult: String = ""
    @State private var showInfo: Bool = false

    @FocusState private var textFieldIsFocused: Bool

    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                Form() {
                    Section(header: Text("Parameters")) {
                        HStack {
                            Text("Age (yrs)")
                            TextField("16-115 yrs", value: $age, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("LV wall thickness (mm)")
                            TextField("10-35 mm", value: $thickness, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("LA diameter (mm)")
                            TextField("28-67 mm", value: $laDiameter, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                        HStack {
                            Text("Gradient (mmHg)")
                            TextField("2-154 mmHg", value: $gradient, formatter: Self.numberFormatter)
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .focused($textFieldIsFocused)
                        }
                    }
                    Section(header: Text("History")) {
                        Toggle(isOn: $familyHxScd) {
                            Text("Family hx SCD")
                        }
                        Toggle(isOn: $hxNsvt) {
                            Text("Hx NSVT")
                        }
                        Toggle(isOn: $hxSyncope) {
                            Text("Hx Syncope")
                        }
                    }
                    Section(header: Text("Result")) {
                        HStack {
                            Text(result)
                            Spacer()
                            Button("Copy") {
                                copy()
                            }
                        }
                    }
                }
                CalculateButtonsView(calculate: calculate, clear: clear)
            }
            .onChange(of: age, perform: { _ in clearResult() })
            .onChange(of: thickness, perform: { _ in clearResult() })
            .onChange(of: laDiameter, perform: { _ in clearResult() })
            .onChange(of: gradient, perform: { _ in clearResult() })
            .onChange(of: familyHxScd, perform: { _ in clearResult() })
            .onChange(of: hxNsvt, perform: { _ in clearResult() })
            .onChange(of: hxSyncope, perform: { _ in clearResult() })
            .navigationBarTitle(Text("HCM SCD 2014"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: { showInfo.toggle() }) {
                Image(systemName: "info.circle")
            }).sheet(isPresented: $showInfo) {
                Info()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func calculate() {
        textFieldIsFocused = false
        let viewModel = HcmViewModel(age: Int(age), thickness: Int(thickness), laDiameter: Int(laDiameter), gradient: Int(gradient), familyHxScd: familyHxScd, hxNsvt: hxNsvt, hxSyncope: hxSyncope)
        result = viewModel.calculate()
        detailedResult = viewModel.getDetails()
    }

    func clear() {
        textFieldIsFocused = false
        clearResult()
        age = 0
        thickness = 0
        laDiameter = 0
        gradient = 0
        familyHxScd = false
        hxNsvt = false
        hxSyncope = false
    }

    func clearResult() {
        result = ""
        detailedResult = ""
    }

    func copy() {
        if !detailedResult.isEmpty {
            copyToClipboard(detailedResult)
        }
    }

    func copyToClipboard(_ s: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = s
    }

//    [EPSSharedMethods showRiskDialogWithMessage:message riskResult:[self getFullRiskReport:message] reference:FULL_REFERENCE url:[[NSURL alloc] initWithString:REFERENCE_LINK] inView:self];
}

private struct Info: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("How to Use")) {
                        Text("Do not use this risk calculator for pediatric patients (<16), elite competitive athletes, HCM associated with metabolic syndromes, or patients with aborted SCD or sustained ventricular arrhythmias.")
                    }
                    Section(header: Text("Definitions")) {
                        Text("HCM = hypertrophic cardiomyopathy.\n\nAge = age at evaluation.\n\nWall thickness = maximum left ventricular wall thickness. Note all echo measurements via transthoracic echo.\n\nLA (left atrial) diameter measured in parasternal long axis.\n\nGradient = maximum left ventricular outflow tract gradient determined at rest and with Valsalva using pulsed and continuous wave Doppler from the apical 3 and 5 chamber views. Peak outflow gradients determined by the modified Bernoulli equation:") + Text("\nGradient = 4V\u{00B2}").italic().bold() + Text("\nwhere V is the peak aortic outflow velocity.\n\nFamily hx of SCD = history of sudden cardiac death in 1 or more first degree relatives under 40 years old or in a first degree relative with confirmed HCM at any age.\n\nNSVT = nonsustained ventricular tachycardia: 3 consecutive ventricular beats at a rate of 120 bpm or more and <30 sec duration on Holter monitoring (minimum 24 hrs) at or prior to evaluation.\n\nHx syncope = history of unexplained syncope at or prior to evaluation")
                    }
                    Section(header: Text("References")) {
                        Text("Elliott PM et al. 2014 ESC guidelines on diagnosis and management of hypertrophic cardiomyopathy. Eur Heart J 2014;35:2733, http://eurheartj.oxfordjournals.org/content/35/39/2733#sec-16\n\nO'Mahony C et al.  Eur Heart J 2014;35:2010, http://eurheartj.oxfordjournals.org/content/35/30/2010.long")
                    }
                }
                Button("Done") {
                    dismiss()
                }
                .roundedButton()
            }
            .navigationBarTitle(Text("HCM SCD 2014"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HcmView_Previews: PreviewProvider {
    static var previews: some View {
        HcmView()
        Info()
    }
}
