//
//  AuthViewModel.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import Foundation
import Firebase
import GoogleSignIn
import UIKit

class AuthViewModel {
    var onSignInSuccess: (() -> Void)?
    var onError: (() -> Void)?
    
    private let userRepository = UserRepository.shared
    
    func signInWithGoogle(vc: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { [weak self] signInResult, error in
            
            guard error == nil else { return }
            
            guard let signInResult = signInResult else { return }
            let user = signInResult.user
            
            let idToken = user.idToken?.tokenString
            let accessToken = user.accessToken.tokenString
            
            let fullName = user.profile?.name
            
            print("Hi \(fullName ?? "")")
            
            guard let idToken = idToken else {
                print("Missing ID Token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase Sign-In failed: \(error.localizedDescription)")
                    return
                }
                
                print("Signed in to Firebase: \(String(describing: result?.user.email))")
                
                if let profile = user.profile {
                    let name = profile.name 
                    let email = profile.email
                    self?.userRepository.saveUser(name: name, email: email)
                }
                
                self?.onSignInSuccess?()
            }
        }
    }
    
    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            userRepository.deleteAllUsers()
            completion(true)
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
            completion(false)
        }
    }
}
