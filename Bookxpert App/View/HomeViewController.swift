//
//  HomeViewController.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 27/05/25.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    let viewModel = AuthViewModel()
    
    private let uploadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Image Upload", for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let viewPDFButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View PDF", for: .normal)
        button.tintColor = .darkGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let viewProductsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Products", for: .normal)
        button.tintColor = .darkGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        view.addSubview(uploadImageButton)
        view.addSubview(viewPDFButton)
        view.addSubview(viewProductsButton)
        view.addSubview(signOutButton)
        
        uploadImageButton.translatesAutoresizingMaskIntoConstraints = false
        viewPDFButton.translatesAutoresizingMaskIntoConstraints = false
        viewProductsButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            uploadImageButton.bottomAnchor.constraint(equalTo: viewPDFButton.topAnchor, constant: -30),
            uploadImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadImageButton.widthAnchor.constraint(equalToConstant: 200),
            uploadImageButton.heightAnchor.constraint(equalToConstant: 50),
            
            viewPDFButton.bottomAnchor.constraint(equalTo: viewProductsButton.topAnchor, constant: -30),
            viewPDFButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewPDFButton.widthAnchor.constraint(equalToConstant: 200),
            viewPDFButton.heightAnchor.constraint(equalToConstant: 50),
            
            viewProductsButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -30),
            viewProductsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewProductsButton.widthAnchor.constraint(equalToConstant: 200),
            viewProductsButton.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 200),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        uploadImageButton.addTarget(self, action: #selector(uploadImageTapped), for: .touchUpInside)

        viewPDFButton.addTarget(self, action: #selector(viewPDFTapped), for: .touchUpInside)
        
        viewProductsButton.addTarget(self, action: #selector(viewProductTapped), for: .touchUpInside)
        
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }
    
    @objc private func uploadImageTapped() {
        let imageVC = ImagePickerViewController()
        self.navigationController?.pushViewController(imageVC, animated: true)
    }
    
    @objc private func viewPDFTapped() {
        let pdfVC = PDFViewerViewController()
        pdfVC.pdfURL = URL(string: "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf")
        self.navigationController?.pushViewController(pdfVC, animated: true)
    }
    
    @objc func viewProductTapped() {
        APIService.shared.fetchObjects { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    APIDataRepository.shared.saveObjects(items)
                    let vc = ProductListViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func signOutTapped() {
        viewModel.signOut { success in
            if success {
                print("Signed out from Firebase")
                DispatchQueue.main.async {
                    // Navigate back to Login screen
                    let loginVC = LoginViewController()
                    let nav = UINavigationController(rootViewController: loginVC)
                    UIApplication.shared.windows.first?.rootViewController = nav
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            } else {
                print("Error during sign-out.")
            }
        }
    }
}

