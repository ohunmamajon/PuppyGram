//
//  ContentView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct ContentView: View {
    
    var currentUserID: String? = "user"
    @Environment(\.colorScheme) var colorScheme
   
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
    }
    
    var body: some View {
        
        
        TabView {
            NavigationView {
                FeedView(posts: PostArrayObject(), title: "Feed")
            }
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Feed")
                    }
            NavigationView {
            BrowseView()
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
                if currentUserID != nil {
                    NavigationView {
                        ProfileView(profileDisplayName: "My profile", profileID: "", isMyProfile: true)
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
