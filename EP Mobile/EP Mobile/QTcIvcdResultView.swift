//
//  QTcIvcdResult.swift
//  EP Mobile
//
//  Created by David Mann on 5/7/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI
import MiniQTc

fileprivate let calculatorName = "QTc with IVCD Results"

struct QTcIvcdResultView: View {
    @State private var showInfo = false
    var qtcIvcdResultList: QTcIvcdResultList
    var qtcFormula: Formula = .qtcBzt
    @Binding var lbbb: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach(qtcIvcdResultList.keys, id: \.self) { key in
                    if let value: String = qtcIvcdResultList[key]
                    {
                        let detail = QTcIvcdViewModel.getDetails(formula: qtcFormula, qtIvcdFormula: key)
                        NavigationLink(destination: QTcIvcdResultDetail(formula: key, value: value, detail: detail, lbbb: $lbbb)) {
                            Text(value)
                        }
                    }
                }
            }
            .navigationBarTitle(calculatorName, displayMode: .inline )
            .navigationBarItems(trailing: NavigationLink(destination: QTcIvcdCalculatorView.getQTcIvcdInformationView(), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
//            .navigationBarItems(trailing: Button(action: { showInfo.toggle() }) {
//                Image(systemName: "info.circle")
//            }.sheet(isPresented: $showInfo) {
//                QTcIvcdCalculatorView.getQTcIvcdInformationView()
//            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct QTcIvcdResultDetail: View {
    @State private var showInfo = false
    var formula: QTcIvcdFormula = .qt
    var value: String
    var detail: String
    @Binding var lbbb: Bool

    var body: some View {
        NavigationView {
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
            .navigationBarTitle("Details", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: QTcIvcdCalculatorView.getQTcIvcdInformationView(), isActive: $showInfo) {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                }
            })
//            .navigationBarItems(trailing: Button(action: { showInfo.toggle() }) {
//                Image(systemName: "info.circle")
//            }.sheet(isPresented: $showInfo) {
//                QTcIvcdCalculatorView.getQTcIvcdInformationView()
//            })
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
        QTcIvcdResultView(qtcIvcdResultList: qtcIvcdResultList, lbbb: .constant(false))
        QTcIvcdResultDetail(formula: .qt, value: "QT = 402 msec", detail: "\n\nUse: The QT varies with heart rate, QRS and sex, and so is usually not a good measure of repolarization independent of these other factors.\n\nFormula: This is the uncorrected QT interval.\n\nNormal values: Not defined.", lbbb: .constant(false))
    }
}
