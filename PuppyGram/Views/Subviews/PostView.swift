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
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    
    enum PostActionSheetOption {
        case general
        case reporting
    }
    
    var showHeaderAndFooter: Bool
    
    var body: some View {
        VStack{
            
            // MARK: Header
            if showHeaderAndFooter{
                HStack{
                    
                    NavigationLink {
                        ProfileView(profileDisplayName: post.userName, profileID: post.userID, isMyProfile: false, posts: PostArrayObject(userID: post.userID))
                    } label: {
                        Image(uiImage: profileImage)
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
                    
                    Button {
                        showActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    }
                    .tint(.primary)
                    .actionSheet(isPresented: $showActionSheet) {
                       getActionSheet()
                    }

                }
                .padding(.all, 6)
            }
            
            // MARK: Image
            
            ZStack{
                Image(uiImage: postImage)
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

                    Button {
                        sharePost()
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }
                    .tint(.primary)
                    Spacer()
                }
                .padding(.all, 6)
             
                HStack {
                    Text(post.caption ?? "")
                    Spacer(minLength: 0)
                }
                .padding(.all, 6)
            }
        }
        .onAppear{
            getImages()
        }
        }
    
    //MARK: Functions
    
    func getImages(){
        ImageManager.instance.downloadProfileImage(userID: post.userID) { returnedImage in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
        
        ImageManager.instance.downloadPostImage(postID: post.postID) { returnedImage in
            if let image = returnedImage {
                self.postImage = image
            }
        }
    }
    
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
    
    func getActionSheet() -> ActionSheet {
        
        switch self.actionSheetType {
            
        case .general:
            return ActionSheet(title: Text("What would you like to do?"), buttons: [
                .destructive(Text("Report")) {
                    self.actionSheetType = .reporting
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showActionSheet.toggle()
                    }
                },
                .default(Text("Learn more...")) {
                    print("lear more pressed")
                },
                
            ])
        case .reporting:
            return ActionSheet(title: Text("Why are you reportingg this post?"), buttons: [
                .destructive(Text("This is inappropriate")) {
                    reportPost(reason: "This is inappropriate")
                },
                .destructive(Text("This is spam")) {
                    reportPost(reason: "This is spam")
                },
                .destructive(Text("It made me uncomfortable")) {
                    reportPost(reason: "It made me uncomfortable")
                },
                .cancel({self.actionSheetType = .general})
            ])
        }
    }
    
    func reportPost(reason: String) {
        
    }
    
    func sharePost() {
        
        let message = "Checkout this post on PuppyGram"
        let image = postImage
        let link = URL(string: "https://www.google.com")!
        
        let activityController = UIActivityViewController(activityItems: [message, image, link], applicationActivities: nil)
        
        let viewController = UIApplication.shared.windows.first?.rootViewController
        
        viewController?.present(activityController, animated: true)
    }
    
}

struct PostView_Previews: PreviewProvider {
    
    static var post: PostModel = PostModel(postID: "", userID: "" ,userName: "Ohun Mamajon", caption: "This is the caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true)
            .previewLayout(.sizeThatFits)
    }
}
