//
//  UploadView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/05.
//

import SwiftUI

struct UploadView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                
                Button {
                    
                } label: {
                    Text("Take photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.yellowColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.MyTheme.purpleColor)
                
                Button {
                    
                } label: {
                    Text("Import Photo".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.purpleColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.MyTheme.yellowColor)
            }
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 15)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
