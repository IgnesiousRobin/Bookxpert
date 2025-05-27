//
//  ProductListViewController.swift
//  Bookxpert App
//
//  Created by Ignesious Robin on 28/05/25.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let viewModel = ProductListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Products"
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadData()
        tableView.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = item.name ?? "No Name"
        let dataString = item.data?.map { "\($0.key): \($0.value.stringValue)" }.joined(separator: ", ") ?? "No Data"
        cell.textLabel?.text = "\(name)\n\(dataString)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]

        let alert = UIAlertController(title: "Update Name", message: "Edit the product name", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.text = item.name
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            guard let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            self.viewModel.updateItem(at: indexPath.row, newName: newName)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }))

        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc private func addTapped() {
        navigationController?.pushViewController(AddItemViewController(), animated: true)
    }
}
