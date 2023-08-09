//
//  ContentView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/03.
//

import SwiftUI

struct ContentView: View {
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
            NavigationView {
                ProfileView(profileDisplayName: "My profile", profileID: "", isMyProfile: true)
            }
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                
            }
        .tint(Color.MyTheme.purpleColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
