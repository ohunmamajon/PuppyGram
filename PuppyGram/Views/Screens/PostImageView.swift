//
//  PostImageView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/06.
//

import SwiftUI

struct PostImageView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    @State var captionText: String = ""
    @Binding var imageSelected: UIImage
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                XMarkButton(dismiss: dismiss)
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                Image(uiImage: imageSelected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
                    .clipped()
                    .padding()
                
                TextField("Add your caption here...", text: $captionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor )
                    .font(.headline)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.sentences)
                
                Button {
                    
                } label: {
                    Text("Post Picture!".uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                        .font(.headline)
                        .cornerRadius(12)
                        .padding()
                }
                .tint(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)

            }
        }
    }
    
// MARK: Functions
    
    func postPicture(){
        print("database")
    }
    
}

struct PostImageView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "dog1")!
    
    static var previews: some View {
        PostImageView(imageSelected: $image)
    }
}
