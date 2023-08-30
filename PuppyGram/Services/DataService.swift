//
//  DataService.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/26.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class DataService {
    
    //MARK: PROPERTIES
    static let instance = DataService()
    
    private var refPost = db.collection("posts")
    
    private var refReports = db.collection("reports")
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    
    //MARK: CREATE FUNCTIONS
    func uploadPost(image: UIImage, caption: String?, displayName: String, userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let document = refPost.document()
        let postID = document.documentID
        
        ImageManager.instance.uploadPostImage(postID: postID, image: image) { success in
            if success {
                
                let postData : [String : Any] = [
                    DatabasePostField.postID : postID,
                    DatabasePostField.userID : userID,
                    DatabasePostField.caption : caption,
                    DatabasePostField.displayName : displayName,
                    DatabasePostField.dateCreated : FieldValue.serverTimestamp()
                ]
                document.setData(postData) { error in
                    if let err = error {
                        print("error uploading data to post")
                        handler(false)
                        return
                    } else {
                        handler(true)
                        return
                    }
                }
            } else {
                handler(false)
                return
            }
            
        }
        
    }
    
    func uploadReport(reason: String, postID: String, handler: @escaping(_ success: Bool)-> ()){
        
        let data: [String: Any] = [
            DatabaseReportField.content : reason,
            DatabaseReportField.postID : postID,
            DatabaseReportField.dateCreated : FieldValue.serverTimestamp()
        ]
        
        refReports.addDocument(data: data) { error in
            if let err = error {
                print("Error uploading report:  \(err)")
                handler(false)
                return
            }
        }
        handler(true)
        return
    }
    
    func uploadComment(postID: String, content: String, displayName: String, userID: String, handler: @escaping (_ success: Bool, _ commentID: String?) -> () ) {
        let document = refPost.document(postID).collection(DatabasePostField.comments).document()
        
        let commentID = document.documentID
        
        let data: [String: Any] = [
            DatabaseCommentField.commentID: commentID,
            DatabaseCommentField.userID: userID,
            DatabaseCommentField.displayName: displayName,
            DatabaseCommentField.content: content,
            DatabaseCommentField.dateCreated: FieldValue.serverTimestamp()
        ]
        
        document.setData(data) { error in
            if let err = error {
                print("error uploading comment")
                handler(false, nil)
                return
            } else {
                handler(true, commentID)
                return
            }
        }
    }
        
    //MARK: GET FUNCTIONS
    
    func downloadPostForUser(userID: String, handler: @escaping(_ posts: [PostModel] ) -> () ){
        refPost.whereField(DatabasePostField.userID, isEqualTo: userID).getDocuments { (querySnapshot, error) in
           
            handler(self.getpostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadPostsForFeed(handler: @escaping(_ posts: [PostModel] ) -> () ){
        refPost.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 50).getDocuments { querySnapshot, error in
            handler(self.getpostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getpostsFromSnapshot(querySnapshot: QuerySnapshot?) -> [PostModel] {
       
        var postArray =  [PostModel]()
        if let snapShot = querySnapshot, snapShot.documents.count > 0 {
            
            for document in snapShot.documents {
                
                if
                    let userID = document.get(DatabasePostField.userID) as? String,
                    let displayName = document.get(DatabasePostField.displayName) as? String,
                    let timestamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                    
                    let caption = document.get(DatabasePostField.caption) as? String
                    let date = timestamp.dateValue()
                    let postID = document.documentID
                    let likeCount = document.get(DatabasePostField.likeCount) as? Double ?? 0
                    
                    var likedByUser: Bool = false
                    if let userIDArray = document.get(DatabasePostField.likedBy) as? [String], let user = currentUserID {
                       likedByUser = userIDArray.contains(userID)
                    }
                    
                    let newPost = PostModel(postID: postID, userID: userID, userName: displayName, caption: caption, dateCreated: date, likeCount: Int(likeCount), likedByUser: likedByUser)
                    postArray.append(newPost)
                }
            }
            return postArray
        } else {
         print("No post document in snapshot for the user")
            return postArray
        }
    }
    
    func downloadComments(postID: String, handler: @escaping (_ comments: [CommentModel]) -> ()) {
        refPost.document(postID).collection(DatabasePostField.comments).order(by: DatabaseCommentField.dateCreated, descending: false).getDocuments { querySnapshot, error in
            handler(self.getCommentsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func getCommentsFromSnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        if let snapShot = querySnapshot, snapShot.documents.count > 0 {
            for document in snapShot.documents {
                if
                    let userID = document.get(DatabaseCommentField.userID) as? String,
                    let displayName = document.get(DatabaseCommentField.displayName) as? String,
                    let content = document.get(DatabaseCommentField.content) as? String,
                    let timeStamp = document.get(DatabaseCommentField.dateCreated) as? Timestamp {
                    
                    let commentID = document.documentID
                    let date = timeStamp.dateValue()
                    let newComment = CommentModel(commentID: commentID, userID: userID, userName: displayName, content: content, dateCreated: date)
                    commentArray.append(newComment)
                }
            }
            return commentArray
        } else {
            print("no comments for this post")
            return commentArray
        }
    }
    
    //MARK: UPDATE FUNCTIONS
    
    func likePost(postID: String, currentUserID: String ) {
        let increment: Double = 1.0
        let data: [String : Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy: FieldValue.arrayUnion([currentUserID])
            
        ]
        
        refPost.document(postID).updateData(data)
    }
    
    func unlikePost(postID: String, currentUserID: String ) {
        let increment: Double = -1.0
        let data: [String : Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy: FieldValue.arrayRemove([currentUserID])
        ]
        
        refPost.document(postID).updateData(data)
    }
    
    
    func updateDisplayNameOnPosts(userID: String, displayName: String) {
        downloadPostForUser(userID: userID) { returnedPosts in
            for post in returnedPosts {
                self.updatePostDisplayName(postID: post.postID, displayName: displayName)
            }
        }
    }
    
    private func updatePostDisplayName(postID: String, displayName: String) {
        
        let data: [String: Any] = [
            DatabasePostField.displayName: displayName
        ]
        
        refPost.document(postID).updateData(data)
    }
    
}
