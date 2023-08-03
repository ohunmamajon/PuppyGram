//
//  FeedView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
           PostView()
            PostView()
            PostView()
            PostView()
            PostView()
            PostView()
        }
    
        .navigationTitle("FeedView")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            FeedView()
        }
    }
}
