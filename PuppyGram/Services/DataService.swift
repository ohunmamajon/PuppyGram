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
        
    
    
}
