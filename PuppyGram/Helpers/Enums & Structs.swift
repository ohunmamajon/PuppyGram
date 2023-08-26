//
//  Enums & Structs.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/25.
//

import Foundation

struct DatabaseUserField{
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider =  "provider"
    static let userID =   "user_id"
    static let bio =  "bio"
    static let dateCreated =  "date_created"
    
}

struct DatabasePostField{
    
    static let postID =   "post_id"
    static let caption =  "caption"
    static let userID =   "user_id"
    static let displayName = "display_name"
    static let dateCreated =  "date_created"
    
}


struct CurrentUserDefaults {
    
    static let displayName = "display_name"
    static let userID =   "user_id"
    static let bio =  "bio"
    
}
