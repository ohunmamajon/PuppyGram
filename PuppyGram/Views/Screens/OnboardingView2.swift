//
//  OnboardingView2.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/12.
//

import SwiftUI
import PhotosUI
struct OnboardingView2: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerID: String
    @Binding var provider: String
    @State var photoItem: PhotosPickerItem?
    @State var selectedImage = UIImage()
    @State var showError: Bool = false
    var body: some View {
        VStack(spacing: 20) {
            
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.yellowColor)
            
            TextField("Add your name...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .font(.headline)
                .textInputAutocapitalization(.sentences)
                .padding(.horizontal)
        
            PhotosPicker("Add your profile picture", selection: $photoItem,
                         matching: .images)
                         .font(.headline)
                         .fontWeight(.bold)
                         .padding()
                         .frame(height: 60)
                         .frame(maxWidth: .infinity)
                         .background(Color.MyTheme.yellowColor)
                         .cornerRadius(12)
                         .padding(.horizontal)
                         .tint(Color.MyTheme.purpleColor)
                         .opacity(displayName  != "" ? 1.0 : 0.0)
                         .animation(.easeInOut(duration: 1.0), value: UUID())
               .onChange(of: photoItem) { _ in
                   Task {
                       if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                           if let uiImage = UIImage(data: data) {
                               selectedImage = uiImage
                               createProfile()
                               return
                           }
                       }
                       print("failed to select image")
                   }
               }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
        .alert(isPresented: $showError) {
            return Alert(title: Text("Error creating a profile 😭"))
        }

    
    }
    
    // MARK: Functions
    func createProfile(){
        AuthService.instance.createNewUserInFirebse(name: displayName, email: email, providerId: providerID, provider: provider, profileImage: selectedImage) { returnedUserID in
            if let userID = returnedUserID {
                AuthService.instance.logInUserToApp(userID: userID) { success in
                    if success {
                        
                    } else {
                        print("Error logging in")
                        self.showError.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.dismiss() }
                    }
                }
            } else {
                print("Error creating a new user")
                self.showError.toggle()
            }
        }
    }
}

struct OnboardingView2_Previews: PreviewProvider {
    
    @State static var test: String = "Test"
    static var previews: some View {
        OnboardingView2(displayName: $test, email: $test, providerID: $test, provider: $test)
    }
}
