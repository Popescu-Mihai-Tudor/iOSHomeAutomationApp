//
//  AuthenticationService.swift
//  LincentaAnPatru
//
//  Created by Mihai on 17.03.2024.
//

import Foundation
import FirebaseAuth
import Combine

class AuthenticationService: ObservableObject {
    
    @Published var isSignedIn: Bool = false
    @Published var currentUserEmail: String?
    
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("User signed in successfully")
                self.isSignedIn = true
                self.currentUserEmail = Auth.auth().currentUser?.email
                completion(true, nil)
            }
        }
    }
    
    func signOut() {
        self.isSignedIn = false
        self.currentUserEmail = nil
    }
}

