//
//  CheckConnectionView.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.02.2024.
//

import SwiftUI

struct CheckConnectionView: View {
    
    @EnvironmentObject var raspberryClient: RaspberryClient
    
    var body: some View {
        Text("Press the button to check connection")
        DisablebleButton(action: raspberryClient.checkConnection, isDisabled: !raspberryClient.canCheckConnection, text: "Check connection")
            .alert("Successfully checked connection", isPresented: $raspberryClient.showAlert) {
                        Button("OK", role: .cancel) { }
                    }
    }
}

#Preview {
    CheckConnectionView()
}
