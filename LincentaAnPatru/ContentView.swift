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
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                CustomButton(action: {
                    self.showMainMenu = true
                }, text: "Main Menu")
                .navigationDestination(isPresented: self.$showMainMenu, destination: {MainMenu()})
                
                Spacer()
                
                CustomButton(action: {client.sendMessage(ledToToggle: 1, completion: {_ in })}, text: "Toggle LED 1")
                
                CustomButton(action: {client.sendMessage(ledToToggle: 2, completion: {_ in })}, text: "Toggle LED 2")
                
                CustomButton(action: {client.sendMessage(ledToToggle: 3, completion: {_ in })}, text: "Toggle LED 3")
                
                CustomButton(action: {client.pollTemperature()}, text: "Check temperature")
                
                if !client.gatheringInformation {
                    Text(client.currentTemperature)
                        .foregroundColor(.red)
                        .bold()
                        .font(.title2)
                    Text(client.currentHumidity)
                        .foregroundColor(.red)
                        .bold()
                        .font(.title2)
                } else {
                    ProgressView()
                        .scaleEffect(2)
                        .padding()
                }
                
                Spacer()
                
                CustomButton(action: {authenticationService.signOut()}, text: "Sign Out")
                
                Spacer()
                Text("Logged in with: \(authenticationService.currentUserEmail ?? "")")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
            }
            .onAppear{
                //Polling for 20 seconds
                //keep for future idea
//                client.startPolling()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: client.stopPolling)
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
        .environmentObject(AuthenticationService()) // Don't forget to add AuthenticationService to the preview environment
}
