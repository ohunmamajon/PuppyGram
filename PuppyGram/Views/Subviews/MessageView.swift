//
//  MessageView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import SwiftUI

struct MessageView: View {
    
    @State var comment: CommentModel
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    
    var body: some View {
        HStack {
            
            // MARK: Profile Image
            NavigationLink {
                LazyView {
                    ProfileView(profileDisplayName: comment.userName, showSettings: false, profileID: comment.userID, isMyProfile: false, posts: PostArrayObject(userID: comment.userID))
                }
            } label: {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }
            
            VStack(alignment: .leading, spacing: 4){
                // MARK: User Name
                Text(comment.userName)
                    .font(.caption)
                    .foregroundColor(.gray)
                // MARK: Content
                Text(comment.content)
                    .padding(.all, 6)
                    .foregroundColor(.primary)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .onAppear {
            getProfileImage()
        }
    }
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: comment.userID) { returnedImage in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {

    static var comment: CommentModel  = CommentModel(commentID: "", userID: "", userName: "Ohun Mamajon", content: "This photo is so cool", dateCreated: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
            .previewLayout(.sizeThatFits)
    }
}
