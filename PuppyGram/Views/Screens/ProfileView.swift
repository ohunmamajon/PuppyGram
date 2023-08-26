//
//  ProfileView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/07.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var profileDisplayName: String
    @State var showSettings: Bool = false
    @State var profileImage : UIImage = UIImage(named:"logo.loading")!
    var profileID: String
    var isMyProfile: Bool
    var body: some View {
        
        var posts = PostArrayObject()
        
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage)
            Divider()
            ImageGridView(posts: posts)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "line.horizontal.3")
                }
                .tint(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                .opacity(isMyProfile ? 1.0 : 0)

            }
        }
        .onAppear{
            getProfileImage()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .preferredColorScheme(colorScheme)
        }
    }
    
    //MARK: FUNCTIONS
    func getProfileImage(){
        ImageManager.instance.downloadProfileImage(userID: profileID) { returnedImage in
            if let image = returnedImage {
                self.profileImage = image
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
