//
//  OnboardingView2.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/12.
//

import SwiftUI
import PhotosUI
struct OnboardingView2: View {
    
    @State var displayName: String = ""
    @State var photoItem: PhotosPickerItem?
    @State var selectedImage = UIImage()
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
        
            PhotosPicker(selection: $photoItem,
                         matching: .images) {
                Label("Finish: Add profile picture", systemImage: "photo")
                   }
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
               .onChange(of: photoItem) { newItem in
                   Task {
                       if let data = try? await newItem?.loadTransferable(type: Data.self) {
                           selectedImage = UIImage(data: data)!
                           createProfile()
                       }
                   }
               }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
    
    }
    
    // MARK: Functions
    func createProfile(){
        
    }
}

struct OnboardingView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView2()
    }
}
