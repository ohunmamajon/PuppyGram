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
    @State var profileBio: String = ""
    @State var showSettings: Bool = false
    @State var profileImage : UIImage = UIImage(named:"logo.loading")!
    var profileID: String
    var isMyProfile: Bool
    var posts : PostArrayObject
    var body: some View {
        
        
        
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView(profileDisplayName: $profileDisplayName, profileBio: $profileBio, profileImage: $profileImage, postArray: posts)
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
            getAdditionalProfileInfo()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage)
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
    
    func getAdditionalProfileInfo(){
        AuthService.instance.getUserInfo(forUserID: profileID) { returnedName, returnedBio in
            if let displayName = returnedName, let bio = returnedBio {
                self.profileDisplayName = displayName
                self.profileBio = bio
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(profileDisplayName: "Joe", profileID: "", isMyProfile: true, posts: PostArrayObject(userID: ""))
        }
    }
}
