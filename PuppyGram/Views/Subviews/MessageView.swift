//
//  MessageView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import SwiftUI

struct MessageView: View {
    
    @State var comment: CommentModel
    
    var body: some View {
        HStack {
            // MARK: Profile Image
            Image("dog1")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(20)
            
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
    }
}

struct MessageView_Previews: PreviewProvider {

    static var comment: CommentModel  = CommentModel(commentID: "", userID: "", userName: "Ohun Mamajon", content: "This photo is so cool", dateCreated: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
            .previewLayout(.sizeThatFits)
    }
}
