//
//  FeedView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var posts: PostArrayObject
    var title: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack
            {
                ForEach(posts.dataArray, id: \.self) { post in
                    PostView(post: post, addHeartAnimationView: true, showHeaderAndFooter: true)
                }
            }
        }
    
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            FeedView(posts: PostArrayObject(shuffled: false), title: "Test")
        }
    }
}
