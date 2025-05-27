//
//  ImagePickerViewModel.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import UIKit

class ImagePickerViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var onImagePicked: ((UIImage) -> Void)?
    
    func openImagePicker(from controller: UIViewController, sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source not available")
            return
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        controller.present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            onImagePicked?(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
