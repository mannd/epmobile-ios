//
//  QTcIvcdResult.swift
//  EP Mobile
//
//  Created by David Mann on 5/7/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct QTcIvcdResultView: View {
    var qtcIvcdResultList: QTcIvcdResultList
    let test = "test"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(qtcIvcdResultList.keys, id: \.self) { key in
                    if let value: String = qtcIvcdResultList[key], let detail = QTcIvcdViewModel.qtcIvcdResultDetails[key] {
                        NavigationLink(destination: Text(value) + Text(detail)) {
                            Text(value)
                        }
                    }
                }
            }
            .navigationBarTitle("QT IVCD Results", displayMode: .inline )
        }
    }
}

struct QTcIvcdResult_Previews: PreviewProvider {
    static let qtcIvcdResultList: QTcIvcdResultList = [.qt: "QT = 440 msec", .qtc: "QTc = 540 msec"]
    static var previews: some View {
        QTcIvcdResultView(qtcIvcdResultList: qtcIvcdResultList)
    }
}
