import SwiftUI
#if canImport(AppKit)
import AppKit
#endif

fileprivate let calculatorName = "HCM AF Risk"

@MainActor
struct HcmAfView: View {
    @StateObject private var ownedViewModel: HcmAfViewModel
    @ObservedObject private var viewModel: HcmAfViewModel
    @State private var showInfo: Bool = false

    init() {
        let vm = HcmAfViewModel()
        _ownedViewModel = StateObject(wrappedValue: vm)
        self.viewModel = vm
    }

    init(viewModel: HcmAfViewModel) {
        _ownedViewModel = StateObject(wrappedValue: viewModel)
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Input Fields
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("LA Diameter (mm)")
                                .frame(width: 180, alignment: .leading)
                            TextField("mm", text: Binding(
                                get: { viewModel.laDiameterInput },
                                set: { viewModel.onLaDiameterChanged($0) }
                            ))
                            .keyboardType(.numbersAndPunctuation)
                            .textFieldStyle(.roundedBorder)
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("Age at Evaluation")
                                .frame(width: 180, alignment: .leading)
                            TextField("years", text: Binding(
                                get: { viewModel.ageAtEvalInput },
                                set: { viewModel.onAgeAtEvalChanged($0) }
                            ))
                            .keyboardType(.numbersAndPunctuation)
                            .textFieldStyle(.roundedBorder)
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("Age at Diagnosis")
                                .frame(width: 180, alignment: .leading)
                            TextField("years", text: Binding(
                                get: { viewModel.ageAtDxInput },
                                set: { viewModel.onAgeAtDxChanged($0) }
                            ))
                            .keyboardType(.numbersAndPunctuation)
                            .textFieldStyle(.roundedBorder)
                        }

                        Toggle(isOn: Binding(
                            get: { viewModel.hfSxChecked },
                            set: { viewModel.onHfSxChanged($0) }
                        )) {
                            Text("History of Heart Failure Symptoms")
                        }
                        .padding(.top, 4)
                    }

                    // Result Display with Copy
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Result")
                                .font(.headline)
                            Spacer()
                            Button("Copy") {
                                copyToPasteboard(viewModel.resultState)
                            }
                            .buttonStyle(.bordered)
                        }

                        Text(viewModel.resultState)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }
                .padding(16)
            }
            .navigationBarTitle(Text(calculatorName), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .navigationDestination(isPresented: $showInfo) {
                InformationView(instructions: HcmAfModel.getInstructions(), key: HcmAfModel.getKey(), references: HcmAfModel.getReferences(), name: calculatorName)
            }
            CalculateButtonsView(calculate: viewModel.calculate, clear: viewModel.clear)
        }
    }

    private func copyToPasteboard(_ text: String) {
        #if canImport(UIKit)
        UIPasteboard.general.string = text
        #elseif canImport(AppKit)
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(text, forType: .string)
        #endif
    }
}

#Preview {
    HcmAfView()
}
