//
//  LikeAnimationView.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/17.
//

import SwiftUI

struct LikeAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        ZStack{
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red).opacity(0.3)
                .font(.system(size: 200))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.3)
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red).opacity(0.6)
                .font(.system(size: 150))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.4)
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red).opacity(0.9)
                .font(.system(size: 100))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(animate ? 1.0 : 0.5)
              
        }
        .animation(Animation.easeInOut(duration: 0.5), value: UUID())
    }
}

struct LikeAnimationView_Previews: PreviewProvider {
    
    @State static var animate: Bool = false
    static var previews: some View {
        LikeAnimationView(animate: $animate)
            .previewLayout(.sizeThatFits)
    }
}
