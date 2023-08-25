//
//  SignInWithGoogle.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class SignInWithGoogle: NSObject {
    
   static let instance = SignInWithGoogle()
    var onboardingView: OnboardingView!
    
    func startSignInWithGoogleFlow(view: OnboardingView) {
        
        self.onboardingView = view
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let prVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: prVC ) { [unowned self] result, error in
          guard error == nil else {
            // ...
              self.onboardingView.showError.toggle()
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              self.onboardingView.showError.toggle()
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            let fullName = user.profile?.name
            let email = user.profile?.email
            
            self.onboardingView.connectToFirebase(name: fullName ?? "", email: email ?? "", provider: "google", crediantial: credential)

          // ...
            return
        }
    }
}
