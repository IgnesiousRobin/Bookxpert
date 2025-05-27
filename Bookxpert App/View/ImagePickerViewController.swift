//
//  ImagePickerViewController.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import UIKit

class ImagePickerViewController: UIViewController {

    private let imageView = UIImageView()
    private let viewModel = ImagePickerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Image Picker"
        view.backgroundColor = .systemBackground
        setupUI()

        imageView.image = UIImage(named: "PreviewImage")

        viewModel.onImagePicked = { [weak self] image in
            self?.imageView.image = image
        }
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let chooseButton = UIButton(type: .system)
        chooseButton.setTitle("Add Image", for: .normal)
        chooseButton.addTarget(self, action: #selector(showImagePickerOptions), for: .touchUpInside)

        view.addSubview(imageView)
        view.addSubview(chooseButton)

        chooseButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),

            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    @objc private func showImagePickerOptions() {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.viewModel.openImagePicker(from: self, sourceType: .camera)
        }))

        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { _ in
            self.viewModel.openImagePicker(from: self, sourceType: .photoLibrary)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
}
