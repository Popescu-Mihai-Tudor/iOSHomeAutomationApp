//
//  ContentView.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var showMainMenu: Bool = false
    @EnvironmentObject var client: RaspberryClient
    @EnvironmentObject var themeProvider: ThemeProvider
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomButton(action: {
                    self.showMainMenu = true
                }, text: "Main Menu")
                .navigationDestination(isPresented: self.$showMainMenu, destination: {MainMenu()})
                CustomButton(action: {client.sendMessage(ledToToggle: 1, completion: {_ in })}, text: "Toggle LED 1")
                CustomButton(action: {client.sendMessage(ledToToggle: 2, completion: {_ in })}, text: "Toggle LED 2")
                CustomButton(action: {client.sendMessage(ledToToggle: 3, completion: {_ in })}, text: "Toggle LED 3")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themeProvider.theme.backgroundColor)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RaspberryClient())
        .environmentObject(ThemeProvider())
}
