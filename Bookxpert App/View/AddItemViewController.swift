//
//  AddItemViewController.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 28/05/25.
//

import UIKit

class AddItemViewController: UIViewController {

    private let viewModel = AddItemViewModel()
    
    private let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Product Name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let keyField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Data Key (e.g. price)"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let valueField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Data Value"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let addPairButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Key-Value Pair", for: .normal)
        return btn
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Product", for: .normal)
        return btn
    }()
    
    private var dataDict: [String: CodableValue] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Product"
        view.backgroundColor = .systemBackground
        setupUI()
        addActions()
    }

    func setupUI() {
        let stack = UIStackView(arrangedSubviews: [nameField, keyField, valueField, addPairButton, saveButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func addActions() {
        addPairButton.addTarget(self, action: #selector(addKeyValuePair), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveProduct), for: .touchUpInside)
    }

    @objc private func addKeyValuePair() {
        guard let key = keyField.text, !key.isEmpty,
              let value = valueField.text, !value.isEmpty else { return }

        if let intValue = Int(value) {
            dataDict[key] = .int(intValue)
        } else if let doubleValue = Double(value) {
            dataDict[key] = .double(doubleValue)
        } else {
            dataDict[key] = .string(value)
        }

        keyField.text = ""
        valueField.text = ""
    }

    @objc private func saveProduct() {
        guard let name = nameField.text, !name.isEmpty else {
            showAlert("Product name is required")
            return
        }

        let item = APIItem(id: UUID().uuidString, name: name, data: dataDict)
        viewModel.save(item: item)

        navigationController?.popViewController(animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Validation", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
