//
//  SignUpView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/12.
//

import SwiftUI

struct SignUpView: View {
    
    @State var showOnboarding: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            
            Text("You are not signed in!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.MyTheme.purpleColor)
            
            Text("Clic the button below to create an account")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Button {
                showOnboarding.toggle()
            } label: {
                Text("Sign in / Sign Up")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .shadow(radius: 12)
            }
            .tint(Color.MyTheme.yellowColor)
            
            Spacer()
            Spacer()
        }
        .padding(.all, 40)
        .background(Color.MyTheme.yellowColor)
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
