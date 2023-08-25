//
//  AuthService.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/25.
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseFirestore

let db = Firestore.firestore()

class AuthService {
    
    //MARK: PROPERTIES
    
    static let instance = AuthService()
    private var ref = db.collection("users")
    
    //MARK: AUTH USER FUNCTIONS
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping(_ providerID: String?, _ isError: Bool) -> ()) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil {
                print("Error logging in to Firebase")
                handler(nil, true)
            }
            
            guard let  providerID = result?.user.uid else {
                print("error getting provider ID")
                handler(nil, true)
                return
            }
            
            handler(providerID, false)
        }
    }
    
    func logInUserToApp(userID: String, handler: @escaping(_ success: Bool) -> ()) {
        getUserInfo(forUserID: userID) { returnedName, returnedBio in
            if let name = returnedName, let bio = returnedBio {
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
                }
                
            } else {
                print("Error getting user info while loggin in")
                handler(false)
            }
        }
    }
    
    func createNewUserInFirebse(name: String, email: String, providerId: String, provider: String, profileImage: UIImage, handler: @escaping(_ userID: String?) -> ()) {
        let document = ref.document()
        let userID = document.documentID
        
        ImageManager.instance.uploadProfileImage(userID: userID, image: profileImage)
        
        let userData: [String: Any] = [
            DatabaseUserField.displayName: name,
            DatabaseUserField.email: email,
            DatabaseUserField.providerID: providerId,
            DatabaseUserField.provider: provider,
            DatabaseUserField.userID: userID,
            DatabaseUserField.bio: "",
            DatabaseUserField.dateCreated: FieldValue.serverTimestamp()
        ]
        
        document.setData(userData) {error in
            if let error = error {
                print("error uploading data to user doc \(error)")
                handler(nil)
            } else {
                handler(userID)
            }
        }
        
        
        
    }
    
    func getUserInfo(forUserID userID: String, handler: @escaping(_ name: String?, _ bio: String?) ->() ) {
        ref.document(userID).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, let name = document.get(DatabaseUserField.displayName) as? String, let bio = document.get(DatabaseUserField.bio) as? String  {
                handler(name, bio)
                return
            } else {
                print("error getting user info!")
                handler(nil, nil)
                return
            }
        }
    }
    
}
