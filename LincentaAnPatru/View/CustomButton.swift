//
//  CustomButton.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import SwiftUI

struct CustomButton: View {
    @EnvironmentObject var themeProvider: ThemeProvider
    var action: () -> Void
    let text: String
    
    var body: some View {
        Button(action: action, label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(themeProvider.theme.enabledButtonColor)
                .frame(width: 200, height: 50)
                .overlay(content: {Text(text).foregroundColor(themeProvider.theme.textColor)})
        })
    }
}

#Preview {
    CustomButton(action: {}, text: "Bton")
}
