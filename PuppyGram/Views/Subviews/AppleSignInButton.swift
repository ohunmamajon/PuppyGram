//
//  AppleSignInButton.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/12.
//

import Foundation
import UIKit
import SwiftUI
import AuthenticationServices

struct AppleSignInButton: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton.init(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
}
