//
//  ImagePicker.swift
//  PuppyGram
//
//  Created by Okhunjon Mamajonov on 2023/08/05.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageSelected: UIImage
       
    @Environment(\.dismiss) var dismiss
       
       public func makeUIViewController(context: Context) -> UIImagePickerController {
           let picker = UIImagePickerController()
           picker.sourceType = .camera
           picker.delegate = context.coordinator
           picker.allowsEditing = true
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
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.imageSelected = image
                dismiss()
            }
        }
    }
}

