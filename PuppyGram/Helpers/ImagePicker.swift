//
//  ImagePicker.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/05.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageSelected: UIImage
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
       
       public func makeUIViewController(context: Context) -> UIImagePickerController {
           let picker = UIImagePickerController()
           picker.sourceType = sourceType
           picker.delegate = context.coordinator
           picker.allowsEditing = false
           return picker
       }
    
      func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
         func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }
        
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any], _ dismiss: DismissAction) {
            if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.imageSelected = image
            }
            dismiss()
        }
    }
}

