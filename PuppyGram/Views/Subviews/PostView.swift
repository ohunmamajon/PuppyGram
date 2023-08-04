//
//  PostView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct PostView: View {
    
    @State var post: PostModel
    
    var body: some View {
        VStack{
            
            // MARK: Header
            HStack{
                Image("dog1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30, alignment: .center)
                    .cornerRadius(15)
                Text(post.userName)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.headline)
            }
            .padding(.all, 6)
            
            // MARK: Image
            Image("dog1")
                .resizable()
                .scaledToFit()
            
            // MARK: Footer
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "heart")
                    .font(.title3)
                Image(systemName: "bubble.middle.bottom")
                    .font(.title3)
                Image(systemName: "paperplane")
                    .font(.title3)
                Spacer()
            }
            .padding(.all, 6)
            
            HStack {
                Text(post.caption)
                Spacer(minLength: 0)
            }
            .padding(.all, 6)
        }
        }
}

struct PostView_Previews: PreviewProvider {
    
    static var post: PostModel = PostModel(postID: "", userID: "" ,userName: "Ohun Mamajon", caption: "This is the caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post: post)
            .previewLayout(.sizeThatFits)
    }
}
