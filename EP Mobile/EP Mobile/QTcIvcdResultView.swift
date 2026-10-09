//
//  QTcIvcdResult.swift
//  EP Mobile
//
//  Created by David Mann on 5/7/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI
import MiniQTc

struct QTcIvcdResultView: View {
    let qtcIvcdResultList: QTcIvcdResultList
    var qtcFormula: Formula = .qtcBzt
    let onShowDetails: (QTcIvcdFormula, String, String) -> Void

    var body: some View {
        List {
            ForEach(qtcIvcdResultList.elements, id: \.key) { element in
                Button {
                    let detail = QTcIvcdViewModel.getDetails(formula: qtcFormula, qtIvcdFormula: element.key)
                    onShowDetails(element.key, element.value, detail)
                } label: {
                    HStack {
                        Text(element.value)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct QTcIvcdResultDetail: View {
    var formula: QTcIvcdFormula = .qt
    let value: String
    let detail: String
    let lbbb: Bool

    var body: some View {
        Form {
            Section(header: Text(formula.description)) {
                VStack {
                    Text(formula.description).bold().frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Text(value).frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Text(getDetail()).multilineTextAlignment(.leading)
                }.padding()
            }
        }
    }

    func getDetail() -> String {
        let lbbbDependentFormulas: Set<QTcIvcdFormula> = [.prelbbbqtc]
        if lbbbDependentFormulas.contains(formula) && !lbbb {
            return ""
        } else {
            return detail
        }
    }
}

struct QTcIvcdResult_Previews: PreviewProvider {
    static let qtcIvcdResultList: QTcIvcdResultList = [.qt: "QT = 440 msec", .qtc: "QTc = 540 msec"]
    static var previews: some View {
        QTcIvcdResultView(qtcIvcdResultList: qtcIvcdResultList, onShowDetails: { _, _, _ in })
        QTcIvcdResultDetail(formula: .qt, value: "QT = 402 msec", detail: "\n\nUse: The QT varies with heart rate, QRS and sex, and so is usually not a good measure of repolarization independent of these other factors.\n\nFormula: This is the uncorrected QT interval.\n\nNormal values: Not defined.", lbbb: false)
    }
}
