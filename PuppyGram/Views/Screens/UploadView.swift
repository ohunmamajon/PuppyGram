//
//  UploadView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/05.
//

import SwiftUI
import UIKit
import PhotosUI

struct UploadView: View {
    
    @State private var showImagePicker: Bool = false
    @State private var showPhotosUIPicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var imageSelected = UIImage()
    @State private var showPostImageView: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                
                Button {
                    showImagePicker.toggle()
                } label: {
                    Text("Take photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.yellowColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.MyTheme.purpleColor)
                
               
                PhotosPicker("Select photo".uppercased(), selection: $photoItem,
                             matching: .images)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .font(.largeTitle)
                .fontWeight(.bold)
                .tint(Color.MyTheme.purpleColor)
                .background(Color.MyTheme.yellowColor)
                .onChange(of: photoItem) { _ in
                    Task {
                        if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                imageSelected = uiImage
                                return
                            }
                        }
                        print("failed to select image")
                    }
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: segueToPostImageView) {
                ImagePicker(imageSelected: $imageSelected, sourceType: .camera)
            }
               
            
            
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 15)
                .fullScreenCover(isPresented: $showPostImageView) {
                    PostImageView(imageSelected: $imageSelected)
                        .preferredColorScheme(colorScheme)
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func segueToPostImageView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPostImageView.toggle()
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        UploadView()
            
    }
}
