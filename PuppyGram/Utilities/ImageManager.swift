//
//  ImageManager.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/25.
//

import Foundation
import FirebaseStorage
import SwiftUI

class ImageManager{
    
    static let instance = ImageManager()
    
    private var ref = Storage.storage()
    
    
    func uploadProfileImage(userID: String, image: UIImage){
        let path = getProfileImagePath(userID: userID)
        
        uploadImage(path: path, image: image) { _ in }
    }
    
    func uploadPostImage(postID: String, image: UIImage, handler: @escaping(_ success: Bool) -> ()) {
        let path = getPostImagePath(postID: postID)
        uploadImage(path: path, image: image) { success in
            handler(success)
        }
    }
    
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        let storagePath = ref.reference(withPath: userPath)
        return storagePath
    }
    
    private func getPostImagePath(postID: String) -> StorageReference {
        let postPath = "posts/\(postID)/1"
        let storagePath = ref.reference(withPath: postPath)
        return storagePath
    }
    
    
    
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping(_ success: Bool) -> ()){
        
        var compression: CGFloat = 1.0
        var maxFileSize: Int = 240 * 240
        let maxCompression: CGFloat = 0.05
        
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data")
            handler(false)
            return
        }
        
        while originalData.count > maxFileSize && compression > maxCompression {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
        }
        
        
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data")
            handler(false)
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        path.putData(finalData, metadata: metaData) { (_ , error) in
            if let err = error {
                print("Error uploading image \(err)")
                handler(false)
                return
            } else {
                print("Success uploading image")
                handler(true)
                return
            }
        }
    }
}
