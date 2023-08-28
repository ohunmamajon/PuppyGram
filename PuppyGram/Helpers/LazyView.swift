//
//  LazyView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/28.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
}
