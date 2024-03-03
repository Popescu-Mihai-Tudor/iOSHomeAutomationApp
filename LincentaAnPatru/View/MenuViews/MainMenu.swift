//
//  MainMenu.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import SwiftUI

struct MainMenu: View {
    
    @EnvironmentObject var themeProvider: ThemeProvider
    let menuViewProvider: MenuViewProvider = MenuViewProvider()
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomButton(action: {print("Profile button pressed")}, text: "Profile")
            Divider()
            ForEach(menuViewProvider.menuViews, id: \.self.name) { menuView in
                NavigationLink(destination: menuView.view) {
                    NavigationButton(text: menuView.name)
                }
            }
            Spacer()
        }
        .padding()
        .background(themeProvider.theme.backgroundColor)
    }
}

#Preview {
    MainMenu()
}
