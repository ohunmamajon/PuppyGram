//
//  PostArrayObject.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import Foundation
class PostArrayObject: ObservableObject {
    @Published var dataArray = [PostModel]()
    
    init() {
        let post1 = PostModel(postID: "", userID: "", userName: "Ohun Mamajon", caption: "Ohun's caption", dateCreated: Date(), likeCount: 2, likedByUser: false)
        let post2 = PostModel(postID: "", userID: "", userName: "John Wick", caption: "John's captions hahahaha", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post3 = PostModel(postID: "", userID: "", userName: "Alex Wood", caption: "Alex's caption", dateCreated: Date(), likeCount: 8, likedByUser: false)
        let post4 = PostModel(postID: "", userID: "", userName: "Anna Frix", caption: "", dateCreated: Date(), likeCount: 0, likedByUser: false)
        
        dataArray.append(contentsOf: [post1, post2, post3, post4])
    }
    
    /// used for post selection
    init(post: PostModel) {
        self.dataArray.append(post)
    }
    
    init(userID: String) {
        DataService.instance.downloadPostForUser(userID: userID) { returnedPosts in
            let sortedPosts = returnedPosts.sorted { post1, post2 in
                return post1.dateCreated > post2.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPosts)
        }
    }
    
    init(shuffled: Bool){
        DataService.instance.downloadPostsForFeed { returnedPosts in
            if shuffled {
                let shuffledPosts = returnedPosts.shuffled()
                self.dataArray.append(contentsOf: shuffledPosts)
            } else {
                self.dataArray.append(contentsOf: returnedPosts)
            }
        }
    }
    
}
