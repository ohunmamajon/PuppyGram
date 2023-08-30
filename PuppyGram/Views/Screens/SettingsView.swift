//
//  SettingsView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/09.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var userDisplayName: String
    @Binding var userBio: String
    @Binding var userProfilePicture: UIImage
    @Environment(\.dismiss) var dismiss
    @State var signOutError: Bool = false
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                // MARK: Section 1: PuppyGram
                GroupBox {
                    HStack(alignment: .center, spacing: 10){
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                        Text("PuppyGram is and Instagram-like app for posting pictures of your dog and sharing them across the world. We are a dog-loving community and happy to have you!")
                            .font(.footnote)
                    }
                } label: {
                    SettingsLabelView(labelText: "PuppyGram", labelImage: "dot.radiowaves.left.and.right")
                }
                .padding()
                
                // MARK: Section 2: Profile
                
                GroupBox {
                    
                    NavigationLink {
                        SettingsEditTextView(profileText: $userDisplayName, submissionText: userDisplayName, title: "Display Name", description: "This Text can be edited", placeholder: "Your display name here...", settingsEditTextOption: .displayName)
                    } label: {
                        SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                    }

                    NavigationLink {
                        SettingsEditTextView(profileText: $userBio, submissionText: userBio, title: "Profile Bio", description: "Write a catchy bio!", placeholder: "Your bio here...", settingsEditTextOption: .bio)
                    } label: {
                        SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                    }

                    
                    NavigationLink {
                        SettingsEditImageView(profileImage: $userProfilePicture, title: "Profile Picture", description: "Your profile will br shown on your profile", selectedImage: userProfilePicture)
                    } label: {
                        SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                    }

                    Button {
                        signOut()
                    } label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color.MyTheme.purpleColor)
                    }
                    .alert(isPresented: $signOutError) {
                        return Alert(title: Text("Error signing out 😶‍🌫️"))
                    }

                   
                } label: {
                    SettingsLabelView(labelText: "Profile", labelImage: "person.fill")
                }
                .padding()

                // MARK: Section 3: Application
              
                GroupBox {
                    
                    Button {
                        openCustomURL(urlString: "https://www.linkedin.com/in/ohunmamajon")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    }

                    Button {
                        openCustomURL(urlString: "https://www.linkedin.com/in/ohunmamajon")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms and Conditions", color: Color.MyTheme.yellowColor)
                    }
                    
                    Button {
                        openCustomURL(urlString: "https://www.linkedin.com/in/ohunmamajon")
                    } label: {
                        SettingsRowView(leftIcon: "globe", text: "PuppyGram Website", color: Color.MyTheme.yellowColor)
                    }
                    
                } label: {
                    SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")
                }
                .padding()


                // MARK: Section 4: Sign Off
                GroupBox {
                  Text("PuppyGram was made by Okhunjon Mamajonov. \n All Rights Reserved \n  Hustling Inc. \n Copyright 2023 👨‍💻")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom, 80)
                
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(dismiss: dismiss)
                }
            }
        }

    }
    
    // MARK: Functions
    
   private func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut(){
        AuthService.instance.logOutUser { success in
            if success {
                self.dismiss()
            } else {
                self.signOutError.toggle()
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var bio: String = "ok"
    @State static var displayName: String = "john"
    @State static var image = UIImage(named: "logo.loading")!
    
    static var previews: some View {
        SettingsView(userDisplayName: $displayName, userBio: $bio, userProfilePicture: $image)
    }
}
