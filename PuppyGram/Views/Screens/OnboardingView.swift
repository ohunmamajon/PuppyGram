//
//  OnboardingView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/12.
//

import SwiftUI
import FirebaseAuth
struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    @State var showOnboarding2: Bool = false
    @State var showError: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            .shadow(radius: 12)
            
            Text("Welcome to PuppyGram")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.purpleColor)
            
            Text("We are a dog-loving community and happy to have you at PuppyGram")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purpleColor)
                .padding()
            
            //MARK: Sign in with Apple
            Button {
                
                SignInWithApple.instance.startSignInWithAppleFlow(view: self)
//                showOnboarding2.toggle()
            } label: {
                AppleSignInButton()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            }

            //MARK: Sign in with Google
            Button {
                SignInWithGoogle.instance.startSignInWithGoogleFlow(view: self)
//                showOnboarding2.toggle()
            } label: {
                HStack {
                    Image(systemName: "globe")
                    
                    Text("Sign in with Google")
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 222/255 , green: 82/255, blue: 70/255))
                .cornerRadius(7)
                .font(.system(size: 23, weight: .medium, design: .default))
            }
            .tint(.white)
            
            Button {
                dismiss()
            } label: {
                Text("Continue as guest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
            }
            .tint(.black)

        }
        .padding(.all, 20)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.beigeColor)
        .fullScreenCover(isPresented: $showOnboarding2, onDismiss: {
            self.dismiss()
        }) {
            OnboardingView2(displayName: $displayName, email: $email, providerID: $providerID, provider: $provider)
        }
        .alert(isPresented: $showError) {
            return Alert(title: Text("Error signing in 😭"))
        }
    }
    
    func connectToFirebase(name: String, email: String, provider: String, crediantial: AuthCredential){
        AuthService.instance.logInUserToFirebase(credential: crediantial) { returnedProviderID, isError in
            if let providerID = returnedProviderID, !isError {
                self.displayName = name
                self.email = email
                self.provider = provider
                self.providerID = providerID
                self.showOnboarding2.toggle()
    
            } else {
                print("Error getting from log in user to Firebase")
                      self.showError.toggle()
            }
        }
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
