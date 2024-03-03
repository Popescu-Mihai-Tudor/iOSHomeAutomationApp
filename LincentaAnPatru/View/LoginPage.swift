import SwiftUI
import Firebase

struct LoginPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject private var authenticationService: AuthenticationService
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Image("login") // Background image named "login"
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 40) // Adjust width and height as needed
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 40) // Adjust width and height as needed
                
                Button("Sign In") {
                    signIn()
                }
                .padding()
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Authentication"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func signIn() {
        authenticationService.signIn(email: email, password: password) { success, error in
            if success {
                showAlert = true
                alertMessage = "Login Successful"
            } else if let error = error {
                showAlert = true
                alertMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
