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
    static let likeCount = "like_count"
    static let likedBy = "liked_by"
    static let comments = "comments"
}

struct DatabaseCommentField {
    
    static let commentID = "comment_id"
    static let displayName = "display_name"
    static let userID =   "user_id"
    static let content = "content"
    static let dateCreated =  "date_created"
    
}


struct CurrentUserDefaults {
    
    static let displayName = "display_name"
    static let userID =   "user_id"
    static let bio =  "bio"
    
}

struct DatabaseReportField {
    
    static let content = "content"
    static let postID = "post_id"
    static let dateCreated =  "date_created"
    
}

enum SettingsEditTextOption {
    case displayName
    case bio
}
