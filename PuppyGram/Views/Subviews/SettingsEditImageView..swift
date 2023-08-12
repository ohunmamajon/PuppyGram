//
//  SettingsEditImageView..swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/11.
//

import SwiftUI
import PhotosUI

struct SettingsEditImageView: View {
    
    @State var title: String
    @State var description: String
    @State var selectedImage = UIImage()
    @State var photoItem: PhotosPickerItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
          Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
                .cornerRadius(12)
            
        
           
                PhotosPicker(selection: $photoItem,
                             matching: .images) {
                    Label("Import".uppercased(), systemImage: "photo")
                       }
                             .frame(maxWidth: .infinity)
                             .frame(height: 60)
                             .font(.title2)
                   .fontWeight(.bold)
                   .tint(Color.MyTheme.purpleColor)
                   .background(Color.MyTheme.yellowColor)
                   .onChange(of: photoItem) { newItem in
                       Task {
                           if let data = try? await newItem?.loadTransferable(type: Data.self) {
                               selectedImage = UIImage(data: data)!
                           }
                       }
                   }
            
            Button {
                
            } label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
            }
            .tint(Color.MyTheme.yellowColor)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle(title)
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            SettingsEditImageView(title: "Test title", description: "Test description")
        }
    }
}
