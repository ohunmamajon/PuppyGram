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
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping(_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String? ) -> ()) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil {
                print("Error logging in to Firebase")
                handler(nil, true, nil, nil)
            }
            
            guard let  providerID = result?.user.uid else {
                print("error getting provider ID")
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIFUserExists(providerID: providerID) { returnedUserID in
                if let userID = returnedUserID {
                    handler(providerID, false, false, userID)
                } else {
                    handler(providerID, false, true, nil)
                }
            }
            
//            handler(providerID, false)
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
    
    func logOutUser(handler: @escaping(_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error\(error)")
            handler(false)
        }
        handler(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
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
    
    private func checkIFUserExists(providerID: String, handler: @escaping(_ userID: String?)->()){
        ref.whereField(DatabaseUserField.providerID, isEqualTo: providerID).getDocuments { (querySnapshot, error) in
            if let snapShot = querySnapshot, snapShot.count > 0, let document = snapShot.documents.first {
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            } else {
                handler(nil)
                return
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
   
    func updateUserDisplayName(userID: String, displayName: String, handler: @escaping(_ success: Bool) -> ()) {
        
        let dataField: [String: Any] = [
            DatabaseUserField.displayName: displayName
        ]
        ref.document(userID).updateData(dataField) { error in
            if let err = error {
                print("Error updating user display Name")
                handler(false)
                return
            } else {
                handler(true)
            }
        }
    }
   
    func updateUserBio(userID: String, bio: String, handler: @escaping(_ success: Bool) -> ()) {
        
        let dataField: [String: Any] = [
            DatabaseUserField.bio: bio
        ]
        ref.document(userID).updateData(dataField) { error in
            if let err = error {
                print("Error updating user display Name")
                handler(false)
                return
            } else {
                handler(true)
            }
        }
    }
    
}
