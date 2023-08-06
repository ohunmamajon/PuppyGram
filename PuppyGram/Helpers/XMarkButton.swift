//
//  XMarkButton.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/06.
//

import SwiftUI

import SwiftUI
 struct XMarkButton: View {
    
     var dismiss: DismissAction?
    
    var body: some View {
        Button(action: {
            dismiss?()
        }, label: {
            Image(systemName: "xmark")
                .font(.title)
                .padding()
        })
        .tint(.primary)


    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(dismiss: nil)
    }
}
