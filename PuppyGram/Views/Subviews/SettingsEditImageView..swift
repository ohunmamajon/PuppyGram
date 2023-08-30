//
//  SettingsEditImageView..swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/11.
//

import SwiftUI
import PhotosUI

struct SettingsEditImageView: View {
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @Binding var profileImage: UIImage
    @Environment(\.dismiss) var dismiss
    @State var title: String
    @State var description: String
    @State var selectedImage = UIImage()
    @State var photoItem: PhotosPickerItem?
    @State var showSuccessAlert: Bool = false
    
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
            
        
           
            PhotosPicker("Import".uppercased(), selection: $photoItem,
                             matching: .images)
                             .frame(maxWidth: .infinity)
                             .frame(height: 60)
                             .font(.title2)
                   .fontWeight(.bold)
                   .tint(Color.MyTheme.purpleColor)
                   .background(Color.MyTheme.yellowColor)
                   .onChange(of: photoItem) { _ in
                       Task {
                           if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                               if let uiImage = UIImage(data: data) {
                                   selectedImage = uiImage
                                   return
                               }
                           }
                           print("failed to select image")
                       }
                   }
            
            Button {
                saveImage()
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
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Saved 🤗"), dismissButton: .default(Text("Ok"), action: {
                self.dismiss()
            }))
        }
    }
    
    func saveImage(){
        guard let userID = currentUserID else {return}
        self.profileImage = selectedImage
        ImageManager.instance.uploadProfileImage(userID: userID, image: selectedImage)
        showSuccessAlert.toggle()
    }
    
}

struct SettingsEditImageView_Previews: PreviewProvider {
    @State static var image = UIImage(named: "logo.loadin")!
    static var previews: some View {
        
        NavigationView{
            SettingsEditImageView(profileImage: $image, title: "Test title", description: "Test description")
        }
    }
}
