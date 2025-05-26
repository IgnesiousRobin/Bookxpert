//
//  LoginViewController.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 26/05/25.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private let viewModel = AuthViewModel()
    private let signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        signInButton.addAction(UIAction(handler: { [weak self] _ in
            self?.signInTapped()
        }), for: .touchUpInside)

        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onSignInSuccess = {
            print("onSignInSuccess::::")
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(HomeViewController(), animated: true)
            }
        }
        viewModel.onError = {
            print("onError::::")
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops", message: "Unable to sign-in!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    @objc private func signInTapped() {
        viewModel.signInWithGoogle(vc: self)
    }
}

