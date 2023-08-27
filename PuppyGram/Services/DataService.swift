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
                    let newPost = PostModel(postID: postID, userID: userID, userName: displayName, caption: caption, dateCreated: date, likeCount: 0, likedByUser: false)
                    postArray.append(newPost)
                }
            }
            return postArray
        } else {
         print("No post document in snapshot for the user")
            return postArray
        }
    }
    
}
