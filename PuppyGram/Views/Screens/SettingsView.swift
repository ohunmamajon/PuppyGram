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
                    SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                    SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                    SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                    SettingsRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color.MyTheme.purpleColor)
                } label: {
                    SettingsLabelView(labelText: "Profile", labelImage: "person.fill")
                }
                .padding()

                // MARK: Section 3: Application
              
                GroupBox {
                    SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    SettingsRowView(leftIcon: "folder.fill", text: "Terms and Conditions", color: Color.MyTheme.yellowColor)
                    SettingsRowView(leftIcon: "globe", text: "PuppyGram Website", color: Color.MyTheme.yellowColor)
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
