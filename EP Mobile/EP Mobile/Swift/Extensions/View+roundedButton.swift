//
//  View+roundedButton.swift
//  EP Mobile
//
//  Created by David Mann on 5/5/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import SwiftUI

struct RoundedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 140, height: 40)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(15)
            .padding()
    }
}

extension View {
    func roundedButton() -> some View {
        modifier(RoundedButton())
    }
}

extension UIButton {
    @objc
    static func roundedButtonConfiguration() -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .medium
        config.background.cornerRadius = 15
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50)
        return config
    }

    @objc
    static func smallRoundedButtonConfiguration() -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .medium
        return config
    }

}
