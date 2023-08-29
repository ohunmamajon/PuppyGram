//
//  CommentsView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import SwiftUI

struct CommentsView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @Environment(\.colorScheme) var colorScheme
    
    @State var commentsArray = [CommentModel]()
    @State var submissionText: String = ""
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    var post: PostModel
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack{
                    ForEach(commentsArray, id: \.self) { comment in
                        MessageView(comment: comment)
                    }
                }
            }
            HStack {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Add a comment here...", text: $submissionText)
                
                Button {
                    if textIsAppropriate() {
                        AddComment()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                }
                .tint( colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            }
            .padding(.all, 6)
            .padding(.bottom)
        }
        .padding(.horizontal)
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getComments()
            getProfilePicture()
        }
    }
    
    func getProfilePicture(){
        guard let userID = currentUserID else {return}
        ImageManager.instance.downloadProfileImage(userID: userID) { returnedImage in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
    
    
    func getComments() {
        
        guard self.commentsArray.isEmpty else { return }
        
        if let caption = post.caption, caption.count > 1 {
            let captionComment = CommentModel(commentID: "", userID: post.userID, userName: post.userName, content: caption, dateCreated: post.dateCreated)
            self.commentsArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: post.postID) { returnedComments in
            self.commentsArray.append(contentsOf: returnedComments)
        }
    }
    
    func textIsAppropriate() -> Bool {
        let badWordArray: [String] = ["shit", "ass"]
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        if submissionText.count < 3 {
            return false
        }
        
        return true
        
    }
   
    func AddComment () {
        
        guard let name = displayName, let userID = currentUserID  else { return }
        
        DataService.instance.uploadComment(postID: post.postID , content: submissionText, displayName: name, userID: userID) { success, returnedCommentID in
            if success, let commentID = returnedCommentID {
                let newComment = CommentModel(commentID: commentID, userID: userID, userName: name, content: submissionText, dateCreated: Date())
                self.commentsArray.append(newComment)
                self.submissionText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
}

struct CommentsView_Previews: PreviewProvider {
    
    static let post = PostModel(postID: "kkb", userID: "jhgk", userName: "kjhkh", dateCreated: Date(), likeCount: 8, likedByUser: false)
    
    static var previews: some View {
        NavigationView {
            CommentsView(post: post)
        }
    }
}
