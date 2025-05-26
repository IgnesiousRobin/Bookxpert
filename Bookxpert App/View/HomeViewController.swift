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
        view.addSubview(signOutButton)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 200),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
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

