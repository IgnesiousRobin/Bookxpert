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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bookxpert App"
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login with Google!"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
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

        view.addSubview(titleLabel)
        view.addSubview(loginLabel)
        view.addSubview(signInButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: loginLabel.topAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.widthAnchor.constraint(equalToConstant: 250),
            
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            loginLabel.heightAnchor.constraint(equalToConstant: 80),
            loginLabel.widthAnchor.constraint(equalToConstant: 250),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            signInButton.heightAnchor.constraint(equalToConstant: 80),
            signInButton.widthAnchor.constraint(equalToConstant: 200)
            
        ])
    }

    private func bindViewModel() {
        viewModel.onSignInSuccess = {
            print("onSignInSuccess::::")
            DispatchQueue.main.async {
                self.navigationController?.setViewControllers([HomeViewController()], animated: true)
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
