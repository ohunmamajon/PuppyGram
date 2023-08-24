//
//  XMarkButton.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/09.
//

import SwiftUI
 struct XMarkButton: View {
    
     var dismiss: DismissAction?
     @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Button(action: {
            dismiss?()
        }, label: {
            Image(systemName: "xmark")
                .font(.title)
                .padding()
                .foregroundColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
        })
        .tint(.primary)


    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(dismiss: nil)
    }
}
