//
//  LincentaAnPatruApp.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct LincentaAnPatruApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var authenticationService: AuthenticationService = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            if authenticationService.isSignedIn {
                ContentView()
                    .environmentObject(authenticationService)
                    .environmentObject(RaspberryClient())
                    .environmentObject(ThemeProvider())
            } else {
                LoginPage()
                    .environmentObject(authenticationService)
            }
        }
    }
}
