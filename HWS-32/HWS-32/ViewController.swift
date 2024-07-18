//
//  ViewController.swift
//  HWS-32
//
//  Created by Comarch-Andrzej on 18/07/2024.
//

import UIKit

class TableViewController: UITableViewController {
	var shoppingList = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		topBarSetup()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shoppingList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = shoppingList[indexPath.row]
		return cell
	}
	
	@objc func addItem() {
		let addItemAlertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
		addItemAlertController.addTextField()
		let submitAction = UIAlertAction(title: "Submit", style: .default) {
			[weak self, weak addItemAlertController] _ in
			guard let answer = addItemAlertController?.textFields?[0].text else { return }
			self?.submit(answer)
		}
		
		addItemAlertController.addAction(submitAction)
		present(addItemAlertController, animated: true)
	}
	
	func submit(_ item: String) {
		if shoppingList.contains(item) {
			showError(title: "Error", message: "Item already in list")
			return
		}
		shoppingList.append(item)
		tableView.beginUpdates()
		tableView.insertRows(at: [IndexPath(row: shoppingList.count - 1, section: 0)], with: .automatic)
		tableView.endUpdates()
	}
	
	@objc func clearList() {
		let clearListAlertController = UIAlertController(title: "Do you want to clear the list?", message: "This action is irreversable", preferredStyle: .alert)
		let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
			self.shoppingList.removeAll()
			self.tableView.reloadData()
		}
		let declineAction = UIAlertAction(title: "No", style: .default) { _ in }
		clearListAlertController.addAction(confirmAction)
		clearListAlertController.addAction(declineAction)
		present(clearListAlertController, animated: true)
	}
	
	@objc func shareList() {
		let shareButtonTapped = UIActivityViewController(activityItems: [shoppingList, "myshoppingList.txt"], applicationActivities: [])
		shareButtonTapped.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(shareButtonTapped, animated: true)
	}
	
	func topBarSetup() {
		title = "Shopping List"
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
		let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareList))
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
		
		navigationItem.leftBarButtonItem = addButton
		navigationItem.rightBarButtonItems = [deleteButton, shareButton]
	}
	
	func showError(title: String, message: String) {
		let errorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let closeAction = UIAlertAction(title: "Close", style: .default)
		errorAlertController.addAction(closeAction)
		present(errorAlertController, animated: true)
	}
}
