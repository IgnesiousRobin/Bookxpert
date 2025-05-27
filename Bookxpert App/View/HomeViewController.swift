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
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
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
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let notificationSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = NotificationSettingsManager.shared.isNotificationEnabled
        return toggle
    }()

    private let notificationStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
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
        // Add buttons to main vertical stack
        mainStackView.addArrangedSubview(uploadImageButton)
        mainStackView.addArrangedSubview(viewPDFButton)
        mainStackView.addArrangedSubview(viewProductsButton)
        view.addSubview(mainStackView)
        
        // Notification toggle setup
        notificationStack.addArrangedSubview(notificationLabel)
        notificationStack.addArrangedSubview(notificationSwitch)
        view.addSubview(notificationStack)

        // Sign out button
        view.addSubview(signOutButton)
        
        // Turn off autoresizing
        [mainStackView, uploadImageButton, viewPDFButton, viewProductsButton, notificationStack, signOutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Apply width constraint to buttons
        [uploadImageButton, viewPDFButton, viewProductsButton].forEach {
            $0.widthAnchor.constraint(equalToConstant: 200).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }

        NSLayoutConstraint.activate([
            // Center main stack near top
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            // Notification toggle above Sign Out
            notificationStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationStack.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -30),
            
            // Sign Out at bottom
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signOutButton.widthAnchor.constraint(equalToConstant: 200),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add targets
        uploadImageButton.addTarget(self, action: #selector(uploadImageTapped), for: .touchUpInside)
        viewPDFButton.addTarget(self, action: #selector(viewPDFTapped), for: .touchUpInside)
        viewProductsButton.addTarget(self, action: #selector(viewProductTapped), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        notificationSwitch.addTarget(self, action: #selector(notificationSwitchToggled), for: .valueChanged)
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
    
    @objc private func notificationSwitchToggled() {
        let isEnabled = notificationSwitch.isOn
        NotificationSettingsManager.shared.isNotificationEnabled = isEnabled
        print("Notifications \(isEnabled ? "enabled" : "disabled")")
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

