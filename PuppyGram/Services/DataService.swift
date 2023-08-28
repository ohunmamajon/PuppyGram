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
    
}
