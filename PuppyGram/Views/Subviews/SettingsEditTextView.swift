//
//  SettingsEditTextView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/10.
//

import SwiftUI




struct SettingsEditTextView: View {
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @Binding var profileText: String
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingsEditTextOption: SettingsEditTextOption
    @State var showSuccessAlert: Bool = false
   
    
    var body: some View {
        VStack(spacing: 20){
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            TextField(placeholder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor )
                .cornerRadius(12)
                .font(.headline)
                .textInputAutocapitalization(.sentences)
            
            Button {
                if textIsAppropriate() {
                    saveText()
                }
            } label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor )
            }
            .cornerRadius(12)
            .tint(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor )
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle(title)
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Saved 🤗"), dismissButton: .default(Text("Ok"), action: {
                self.dismiss()
            }))
        }

    }
    
   private func textIsAppropriate() -> Bool {
        let badWordArray: [String] = ["shit", "ass"]
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        if submissionText.count < 3 {
            return false
        }
        
        return true
        
    }
   
    func saveText(){
        
        guard let userID = currentUserID else {return}
        
        switch settingsEditTextOption {
        case .displayName:
            self.profileText = submissionText
           UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.displayName)
            DataService.instance.updateDisplayNameOnPosts(userID: userID, displayName: submissionText)
            AuthService.instance.updateUserDisplayName(userID: userID, displayName: submissionText) { success in
                if success {
                    showSuccessAlert.toggle()
                }
            }
            break
        case .bio:
            self.profileText = submissionText
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
            AuthService.instance.updateUserBio(userID: userID, bio: submissionText) { success in
                if success {
                    showSuccessAlert.toggle()
                }
            }
            break
        }
    }
    
}

struct SettingsEditTextView_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        NavigationView{
            SettingsEditTextView(profileText: $text, title: "Test title", description: "Test description. Test is test and you know that", placeholder: "Test placeholder", settingsEditTextOption: .bio)
        }
    }
}
