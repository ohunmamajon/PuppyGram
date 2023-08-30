//
//  PostView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct PostView: View {
    
   
    
   
    @State var post: PostModel
    @State var animateLike: Bool = false
    @State var addHeartAnimationView : Bool = false
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showReportAlert: Bool = false
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    
    
    var showHeaderAndFooter: Bool
    
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        VStack{
            
            var captionName = post.userName.split(separator: " ").joined()
            
            // MARK: Header
            if showHeaderAndFooter{
                HStack{
                    
                    NavigationLink {
                        LazyView {
                            ProfileView(profileDisplayName: post.userName, profileID: post.userID, isMyProfile: false, posts: PostArrayObject(userID: post.userID))
                        }
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
                    .aspectRatio(1, contentMode: .fit)
                    
                    .onTapGesture(count: 2 , perform: {
                        if !post.likedByUser {
                            likePost()
                            AnalyticsService.instance.likePostDoubleTapped()
                        }
                    })
                
                if addHeartAnimationView { LikeAnimationView(animate: $animateLike)
                    
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
                            AnalyticsService.instance.likePostHeartPressed()
                        }
                        
                    } label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .tint(post.likedByUser ? .red : .primary)

                    
                    // MARK: Comment Icon
                    
                    NavigationLink {
                        CommentsView(post: post)
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
                    if let caption = post.caption, caption.count > 1{
                        Text("**\(captionName.lowercased())** \(caption)")
                        Spacer(minLength: 0)
                    } else {
                        Text("")
                    }
                }
                .padding(.all, 5)
                .padding(.leading, 6)
                .padding(.bottom, 6)
            }
        }
        .onAppear{
            getImages()
        }
        .alert(isPresented: $showReportAlert) {
            return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
        animateLike = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            animateLike = false
        }
        
        guard let userID = currentUserID else { print("cannot find find user id while liking the post")
            return
        }
        
        DataService.instance.likePost(postID: post.postID, currentUserID: userID)
        
  }
    func unlikePost(){
        let upDatedPost = PostModel(postID: post.postID, userID: post.userID, userName: post.userID, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, likedByUser: false)
        self.post = upDatedPost
        
        guard let userID = currentUserID else { print("cannot find find user id while unliking the post")
            return
        }
        
        DataService.instance.unlikePost(postID: post.postID, currentUserID: userID)
        
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
        DataService.instance.uploadReport(reason: reason, postID: post.postID) { success in
            if success {
                self.alertTitle = "Reported!"
                self.alertMessage = "Thanks for reporting! We will review it shortly and take the appropriate action"
                self.showReportAlert.toggle()
            } else {
                self.alertTitle = "Error"
                self.alertMessage = "There was an error reporting! Pleaser restart the app and try again!"
                self.showReportAlert.toggle()
            }
        }
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
