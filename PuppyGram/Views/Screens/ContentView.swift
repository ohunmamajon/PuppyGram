//
//  ContentView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.colorScheme) var colorScheme
   
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
    }
    
    let feedPosts = PostArrayObject(shuffled: false)
    let browsePosts = PostArrayObject(shuffled: true)
    
    var body: some View {
        
        
        TabView {
            NavigationView {
                FeedView(posts: feedPosts, title: "Feed")
            }
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Feed")
                    }
            NavigationView {
                BrowseView(posts: browsePosts)
            }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Browse")
                    }
               UploadView()
                    .tabItem {
                        
                        Image(systemName: "square.and.arrow.up.fill")
                        Text("Upload")
                    }
            ZStack{
                if let userID = currentUserID , let name = displayName {
                    NavigationView {
                        ProfileView(profileDisplayName: name, profileID: userID, isMyProfile: true, posts: PostArrayObject(userID: userID))
                    }
                } else {
                    SignUpView()
                }
            }
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                
            }
        .tint(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
