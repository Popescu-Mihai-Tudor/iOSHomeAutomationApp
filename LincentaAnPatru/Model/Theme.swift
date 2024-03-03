//
//  Theme.swift
//  LincentaAnPatru
//
//  Created by Mihai on 03.03.2024.
//

import Foundation
import SwiftUI

protocol Theme {
    var textColor: Color { get }
    var enabledButtonColor: Color { get }
    var disabledButtonColor: Color { get }
    var backgroundColor: Color { get }
}

struct LightTheme: Theme {
    var textColor: Color = .cyan
    
    var enabledButtonColor: Color = .gray
    
    var disabledButtonColor: Color = .red
    
    var backgroundColor: Color = .mint
}

struct DarkTheme: Theme {
    var textColor: Color = .red
    
    var enabledButtonColor: Color = .blue
    
    var disabledButtonColor: Color = .orange
    
    var backgroundColor: Color = .black
}

class ThemeProvider: ObservableObject {
    var theme = DarkTheme()
}
