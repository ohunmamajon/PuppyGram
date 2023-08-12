//
//  SettingsView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/09.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                       SettingsEditTextView(submissionText: "Current Display Name", title: "Display Name", description: "This Text can be edited", placeholder: "Your display name here...")
                    } label: {
                        SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                    }

                    NavigationLink {
                        SettingsEditTextView(submissionText: "Current bio here", title: "Profile Bio", description: "Write a catchy bio!", placeholder: "Your bio here...")
                    } label: {
                        SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                    }

                    
                    NavigationLink {
                        SettingsEditImageView(title: "Profile Picture", description: "Your profile will br shown on your profile")
                    } label: {
                        SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                    }

                    SettingsRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color.MyTheme.purpleColor)
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
