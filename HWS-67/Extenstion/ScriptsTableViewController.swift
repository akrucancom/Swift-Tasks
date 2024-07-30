//
//  ScriptsTableViewController.swift
//  Extenstion
//
//  Created by Comarch-Andrzej on 24/07/2024.
//

import UIKit

class ScriptsTableViewController: UITableViewController {
	var scriptsKey = ""
	var scripts = [Script]()

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return scripts.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = scripts[indexPath.row].name

		let deleteButton = UIButton(type: .system)
		deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
		deleteButton.tintColor = .systemGray
		deleteButton.tag = indexPath.row
		deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)

		cell.contentView.addSubview(deleteButton)
		deleteButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
			deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
			deleteButton.widthAnchor.constraint(equalToConstant: 30),
			deleteButton.heightAnchor.constraint(equalToConstant: 30)
		])
		
		return cell
	}

	@objc func deleteItem(_ sender: UIButton) {
		let deleteAlertController = UIAlertController(title: "Delete \(scripts[sender.tag].name)?", message: "This action cannot be undone", preferredStyle: .alert)
		let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { [ weak self ] _ in
			self?.scripts.remove(at: sender.tag)
			let indexPath = [IndexPath(row: sender.tag, section: 0)]
			self?.tableView.deleteRows(at: indexPath, with: .automatic)
			self?.save()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		
		deleteAlertController.addAction(confirmAction)
		deleteAlertController.addAction(cancelAction)
		present(deleteAlertController, animated: true)
	}

	func save() {
		let jsonEncoder = JSONEncoder()
		if let savedData = try? jsonEncoder.encode(scripts) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: scriptsKey)
			print("Saved")
		} else {
			print("Failed to save scripts.")
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let rootVC = navigationController?.viewControllers.first as? ActionViewController {
			rootVC.script.text = scripts[indexPath.row].content
			rootVC.scriptName = scripts[indexPath.row].name
			rootVC.scripts = scripts
		}
		navigationController?.popToRootViewController(animated: true)
	}
}
