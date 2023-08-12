//
//  OnboardingView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/12.
//

import SwiftUI

struct OnboardingView: View {
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
            
            Button {
                
            } label: {
                AppleSignInButton()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            }

            Button {
                
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
        }
        .padding(.all, 20)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.beigeColor)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
