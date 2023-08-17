//
//  PostView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct PostView: View {
    
    @State var post: PostModel
    @State var anmateLike: Bool = false
    
    @State var addHeartAnimationView : Bool = false
    
    var showHeaderAndFooter: Bool
    
    var body: some View {
        VStack{
            
            // MARK: Header
            if showHeaderAndFooter{
                HStack{
                    
                    NavigationLink {
                        ProfileView(profileDisplayName: post.userName, profileID: post.userID, isMyProfile: false)
                    } label: {
                        Image("dog1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30, alignment: .center)
                            .cornerRadius(15)
                        Text(post.userName)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .font(.headline)
                }
                .padding(.all, 6)
            }
            
            // MARK: Image
            
            ZStack{
                Image("dog1")
                    .resizable()
                    .scaledToFit()
                
                if addHeartAnimationView { LikeAnimationView(animate: $anmateLike)
                    
                }
            }
            
            // MARK: Footer
            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20) {
                    
                    Button {
                        if post.likedByUser {
                            unlikePost()
                        } else {
                            likePost()
                        }
                        
                    } label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .tint(post.likedByUser ? .red : .primary)

                    
                    // MARK: Comment Icon
                    
                    NavigationLink {
                        CommentsView()
                    } label: {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }

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
    
    //MARK:
    func likePost(){
        let upDatedPost = PostModel(postID: post.postID, userID: post.userID, userName: post.userID, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount + 1, likedByUser: true)
        self.post = upDatedPost
        anmateLike = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            anmateLike = false
        }
  }
    func unlikePost(){
        let upDatedPost = PostModel(postID: post.postID, userID: post.userID, userName: post.userID, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, likedByUser: false)
        self.post = upDatedPost
    }
}

struct PostView_Previews: PreviewProvider {
    
    static var post: PostModel = PostModel(postID: "", userID: "" ,userName: "Ohun Mamajon", caption: "This is the caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true)
            .previewLayout(.sizeThatFits)
    }
}
