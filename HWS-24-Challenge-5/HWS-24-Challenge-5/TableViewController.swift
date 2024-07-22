//
//  TableViewController.swift
//  HWS-24-Challenge-5
//
//  Created by Comarch-Andrzej on 16/07/2024.
//

import UIKit

class TableViewController: UITableViewController {
	var websites = ["apple.com", "hackingwithswift.com"]

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Web Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return websites.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Websites", for: indexPath)
		cell.textLabel?.text = websites[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let viewController = storyboard?.instantiateViewController(withIdentifier: "WebsiiteView") as? ViewController {
			navigationController?.pushViewController(viewController, animated: true)
			viewController.startWebsiteIndex = indexPath.row
			viewController.websites = websites
		}
	}
}
