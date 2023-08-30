//
//  ImageGridView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/05.
//

import SwiftUI

let width = UIScreen.main.bounds.width

struct ImageGridView: View {
    
    @ObservedObject var posts: PostArrayObject
    
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()),
                      GridItem(.flexible()),
                      GridItem(.flexible())],
            alignment: .center ,
            spacing: nil,
            pinnedViews: [] ) {
                
                ForEach(posts.dataArray) { post in
                   
                    NavigationLink {
                        FeedView(posts: PostArrayObject(post: post), title: "Post")
                    } label: {
                        PostView(post: post, showHeaderAndFooter: false)
                    }
                }
            }
    
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(posts: PostArrayObject(shuffled: true))
            .previewLayout(.sizeThatFits)
    }
}
