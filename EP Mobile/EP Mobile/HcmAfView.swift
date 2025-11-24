import SwiftUI
#if canImport(AppKit)
import AppKit
#endif

@MainActor
struct HcmAfView: View {
    @StateObject private var ownedViewModel: HcmAfViewModel
    @ObservedObject private var viewModel: HcmAfViewModel

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
        ScrollView {
            VStack(alignment: .center, spacing: 12) {
                // Input Fields
                Group {
                    TextField("LA Diameter (mm)", text: Binding(
                        get: { viewModel.laDiameterInput },
                        set: { viewModel.onLaDiameterChanged($0) }
                    ))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                    TextField("Age at Evaluation", text: Binding(
                        get: { viewModel.ageAtEvalInput },
                        set: { viewModel.onAgeAtEvalChanged($0) }
                    ))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                    TextField("Age at Diagnosis", text: Binding(
                        get: { viewModel.ageAtDxInput },
                        set: { viewModel.onAgeAtDxChanged($0) }
                    ))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                }

                // Checkbox / Toggle
                Toggle(isOn: Binding(
                    get: { viewModel.hfSxChecked },
                    set: { viewModel.onHfSxChanged($0) }
                )) {
                    Text("History of Heart Failure Symptoms")
                }
                .padding(.vertical, 8)

                // Action Buttons
                HStack(spacing: 8) {
                    Button("Calculate") {
                        viewModel.calculate()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Button("Clear") {
                        viewModel.clear()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button("Copy") {
                        copyToPasteboard(viewModel.resultState)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }

                // Result Display
                VStack(alignment: .leading) {
                    Text(viewModel.resultState)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.top, 8)
            }
            .padding(16)
        }
        .navigationTitle("HCM-AF")
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
    NavigationView {
        HcmAfView()
    }
}
