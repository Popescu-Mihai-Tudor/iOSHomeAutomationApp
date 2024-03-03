//
//  NavigationButton.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import SwiftUI

struct NavigationButton: View {
    @EnvironmentObject var themeProvider: ThemeProvider
    let text: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(themeProvider.theme.enabledButtonColor)
            .frame(width: 200, height: 50)
            .overlay(content: {Text(text).foregroundColor(themeProvider.theme.textColor)})
    }
}

#Preview {
    NavigationButton(text: "aksjdhakjds")
}
