//
//  CommentsView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import SwiftUI

struct CommentsView: View {
    
    @State var commentsArray = [CommentModel]()
    @State var submissionText: String = ""
    @Environment(\.colorScheme) var colorScheme
    
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
                Image("dog1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Add a comment here...", text: $submissionText)
                
                Button {
                    
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
        }
    }
    
    func getComments() {
        let comment1 = CommentModel(commentID: "", userID: "", userName: "Ohun Mamajon", content: "This is 1 comment", dateCreated: Date())
        let comment2 = CommentModel(commentID: "", userID: "", userName: "John Wick", content: "This is 2 comments", dateCreated: Date())
        let comment3 = CommentModel(commentID: "", userID: "", userName: "Chris Hemsworth", content: "This is 3 comments", dateCreated: Date())
        let comment4 = CommentModel(commentID: "", userID: "", userName: "Stephen Joe", content: "This is 4 comments", dateCreated: Date())
        commentsArray.append(contentsOf: [comment1, comment2, comment3, comment4])
    }
    
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommentsView()
        }
    }
}
