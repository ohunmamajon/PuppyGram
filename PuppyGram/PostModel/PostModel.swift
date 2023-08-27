//
//  PostModel.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import Foundation
struct PostModel: Identifiable, Hashable {
    
    var id = UUID()
    var postID: String
    var userID: String
    var userName: String
    var caption: String?
    var dateCreated: Date
    var likeCount: Int
    var likedByUser: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
