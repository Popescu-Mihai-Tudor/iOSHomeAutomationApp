//
//  DisablebleButton.swift
//  LincentaAnPatru
//
//  Created by Mihai on 03.03.2024.
//

import SwiftUI

struct DisablebleButton: View {
    
    @EnvironmentObject var themeProvider: ThemeProvider
    var action: () -> Void
    var isDisabled: Bool
    let text: String
    
    var body: some View {
        Button(action: action, label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(isDisabled ? themeProvider.theme.disabledButtonColor : themeProvider.theme.enabledButtonColor)
                .frame(width: 200, height: 50)
                .overlay(content: {Text(text).foregroundColor(themeProvider.theme.textColor)})
        })
        .disabled(isDisabled)
    }
}

#Preview {
    DisablebleButton(action: {}, isDisabled: true, text: "")
}
