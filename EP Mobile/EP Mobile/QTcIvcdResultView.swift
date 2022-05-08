//
//  QTcIvcdResult.swift
//  EP Mobile
//
//  Created by David Mann on 5/7/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct QTcIvcdResultView: View {
    @Binding var qtcIvcdResult: QTcIvcdResult
    
    var body: some View {
        NavigationView {
            List {
                    HStack {
                        Text(qtcIvcdResult.qt)

                    }
            }
        }
    }
}

struct QTcIvcdResult_Previews: PreviewProvider {
    static let qtcIvcdResult: QTcIvcdResult = QTcIvcdResult(qt: "QT", qtc: "QTc", jt: "JT", jtc: "JTc", qtm: "QTm", qtmc: "QTmc", qtrrqrs: "QTrr,qrs", prelbbbqtc: "preLBBBQTc")
    static var previews: some View {
        QTcIvcdResultView(qtcIvcdResult: .constant(qtcIvcdResult))
    }
}
