//
//  ImageManager.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/25.
//

import Foundation
import FirebaseStorage
import SwiftUI

let imageCache = NSCache<AnyObject, UIImage>()

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
    
    func downloadProfileImage(userID: String, handler: @escaping(_ image: UIImage?) -> ()){
        let path = getProfileImagePath(userID: userID)
        
        downloadImage(path: path) { returnedImage in
            handler(returnedImage)
        }
        
    }
    
    func downloadPostImage(postID: String, handler: @escaping(_ image: UIImage?) -> ()) {
        let path = getPostImagePath(postID: postID)
        downloadImage(path: path) { returnedImage in
            handler(returnedImage)
        }
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
    
    private func downloadImage(path: StorageReference, handler: @escaping(_ image: UIImage?) -> ()) {
        
        
        if let cachedImage = imageCache.object(forKey: path) {
            handler(cachedImage)
            print("getting image from cache")
            return
        } else {
            path.getData(maxSize: 27 * 1024 * 1024) { returnedImageData, error in
                if let data = returnedImageData, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: path)
                handler(image)
                    print("downloading image from Firebase")
                    return
                } else {
                    handler(nil)
                    return
                }
            }
        }
        }
    
}
