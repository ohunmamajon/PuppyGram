//
//  ProfileView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/07.
//

import SwiftUI

struct ProfileView: View {
    
    @State var profileDisplayName: String
    var profileID: String
    var isMyProfile: Bool
    
    var body: some View {
        
        var posts = PostArrayObject()
        
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView(profileDisplayName: $profileDisplayName)
            Divider()
            ImageGridView(posts: posts)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "line.horizontal.3")
                }
                .tint(Color.MyTheme.purpleColor)
                .opacity(isMyProfile ? 1.0 : 0)

            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(profileDisplayName: "Joe", profileID: "", isMyProfile: true)
        }
    }
}