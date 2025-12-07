//
//  HcmAfViewModel.swift
//  EP Mobile
//
//  Copyright (C) 2025 EP Studios, Inc.
//  www.epstudiossoftware.com
//
//  Created by ChatGPT on 11/23/25.
//
//  This file is part of EP Mobile.
//
//  EP Mobile is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  EP Mobile is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with EP Mobile.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

@MainActor
class HcmAfViewModel: ObservableObject {
    // MARK: - User Input State
    @Published var laDiameterInput: String = ""
    @Published var ageAtEvalInput: String = ""
    @Published var ageAtDxInput: String = ""
    @Published var hfSxChecked: Bool = false

    // MARK: - Output State
    @Published var resultState: String = "Enter values to see result."

    // MARK: - Input Handlers (optional, for clarity or custom logic)
    func onLaDiameterChanged(_ newText: String) { laDiameterInput = newText }
    func onAgeAtEvalChanged(_ newText: String) { ageAtEvalInput = newText }
    func onAgeAtDxChanged(_ newText: String) { ageAtDxInput = newText }
    func onHfSxChanged(_ isChecked: Bool) { hfSxChecked = isChecked }

    func clear() {
        laDiameterInput = ""
        ageAtEvalInput = ""
        ageAtDxInput = ""
        hfSxChecked = false
        resultState = "Enter values to see result."
    }

    // MARK: - Calculation Logic
    func calculate() {
        let laDiameter = Int(laDiameterInput)
        let ageAtEval = Int(ageAtEvalInput)
        let ageAtDx = Int(ageAtDxInput)
        let hfSx = hfSxChecked

        let model = HcmAfModel(
            laDiameter: laDiameter,
            ageAtEval: ageAtEval,
            ageAtDx: ageAtDx,
            hfSx: hfSx
        )
        let pointsResult = model.getPoints()

        let message: String
        switch pointsResult {
        case .success(let points):
            if let riskData = HcmAfModel.riskData(for: points) {
                message = """
HCM-AF Score: \(points)
\(riskData.riskCategory.rawValue)
2-Year AF Risk: \(riskData.riskAt2YearsPercent)%
5-Year AF Risk: \(riskData.riskAt5YearsPercent)%
"""
            } else {
                message = "Score (\(points)) is out of valid range (8-31)."
            }
        case .failure(let error):
            switch error {
            case .laDiameterOutOfRange:
                message = "Error: LA Diameter must be between 24 and 65 mm."
            case .ageAtEvalOutOfRange:
                message = "Error: Age at Evaluation must be between 10 and 79."
            case .ageAtDxOutOfRange:
                message = "Error: Age at Diagnosis must be between 0 and 79."
            case .parsingError:
                message = "Please enter all values."
            }
        }
        resultState = message
    }
}

