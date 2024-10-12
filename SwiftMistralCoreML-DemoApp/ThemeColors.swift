//
//  ThemeColors.swift
//  SwiftMistralCoreML-DemoApp
//
//  Created by Oscar Cardona on 6/10/24.
//

import SwiftUI

struct ThemeColors {
    let background: Color
    let text: Color
    let border: Color
    let accent: Color
    let buttonText: Color
    let buttonBackground: Color
    
    static func colors(for theme: Theme) -> ThemeColors {
        switch theme {
        case .dark:
            return ThemeColors(
                background: Color.black,
                text: Color.green,
                border: Color.green,
                accent: Color.green,
                buttonText: Color.black,
                buttonBackground: Color.green
            )
        case .light:
            return ThemeColors(
                background: Color.white,
                text: Color.black,
                border: Color.blue,
                accent: Color.blue,
                buttonText: Color.white,
                buttonBackground: Color.blue
            )
        }
    }
}
