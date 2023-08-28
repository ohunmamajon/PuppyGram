//
//  PostArrayObject.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import Foundation
class PostArrayObject: ObservableObject {
    @Published var dataArray = [PostModel]()
  
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
