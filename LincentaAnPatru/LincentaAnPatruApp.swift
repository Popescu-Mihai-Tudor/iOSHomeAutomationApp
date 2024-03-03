//
//  LincentaAnPatruApp.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import SwiftUI

@main
struct LincentaAnPatruApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(RaspberryClient())
                .environmentObject(ThemeProvider())
        }
    }
}
