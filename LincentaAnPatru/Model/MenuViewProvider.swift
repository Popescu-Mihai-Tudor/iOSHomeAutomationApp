//
//  MenuViewProvider.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import Foundation
import SwiftUI

class MenuViewProvider {
    
    var menuViews: [MenuView] = [
        MenuView(name: "Functionalities", view: AnyView(FunctionalitiesView())),
        MenuView(name: "Settings", view: AnyView(SettingsView())),
        MenuView(name: "Check Connection", view: AnyView(CheckConnectionView())),
        MenuView(name: "About", view: AnyView(AboutView())),
    ]
    
}

struct MenuView {

    let name: String
    let view: AnyView
}
