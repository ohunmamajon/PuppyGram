//
//  PostArrayObject.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/04.
//

import Foundation
class PostArrayObject: ObservableObject {
    @Published var dataArray = [PostModel]()
    @Published var postCount = "0"
    @Published var likeCount = "0"
    
    
    /// used for post selection
    init(post: PostModel) {
        self.dataArray.append(post)
    }
    
    init(userID: String) {
        DataService.instance.downloadPostForUser(userID: userID) { returnedPosts in
            let sortedPosts = returnedPosts.sorted { post1, post2 in
                return post1.dateCreated > post2.dateCreated
            }
            print("post created")
            self.dataArray.append(contentsOf: sortedPosts)
            self.updateCounts()
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
    
    func updateCounts(){
        self.postCount = "\(self.dataArray.count)"
       
        let likeCountArray = dataArray.map { (existingPost) -> Int in
            return existingPost.likeCount
        }
        let sumOfLike = likeCountArray.reduce(0, +)
        self.likeCount = "\(sumOfLike)"
    }
    
}
