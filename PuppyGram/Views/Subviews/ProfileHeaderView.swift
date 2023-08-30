//
//  ProfileHeaderView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/07.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @Binding var profileDisplayName: String
    @Binding var profileBio: String
    @Binding var profileImage: UIImage
    
    @ObservedObject var postArray: PostArrayObject
    
    
    var body: some View {
        VStack {
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if profileBio != "" {
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            HStack(alignment: .center, spacing: 20) {
                
                // MARK: Post
                VStack(alignment: .center, spacing: 5) {
                    Text(postArray.postCount)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                
                // MARK: Likes
                VStack(alignment: .center, spacing: 5) {
                    Text(postArray.likeCount)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Likes")
                        .font(.callout)
                        .fontWeight(.medium)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    @State static var name: String = "Joe"
    @State static var image : UIImage = UIImage(named: "logo.loading")!
    @State static var profBio: String = ""
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileBio: $profBio, profileImage: $image, postArray: PostArrayObject(shuffled: false))
            .previewLayout(.sizeThatFits)
    }
}
