//
//  ViewController.swift
//  HWS-Project1
//
//  Created by Comarch-Andrzej on 11/07/2024.
//

import UIKit

class ViewController: UITableViewController {
	var pictures = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let fileManager = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fileManager.contentsOfDirectory(atPath: path)
		
		performSelector(inBackground: #selector(loadImages), with: items)
		pictures.sort()
		print(pictures)
	}
	
	@objc func loadImages(items: [String]) {
		for item in items {
			if item.hasPrefix("nssl") {
				pictures.append(item)
			}
		}
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = pictures[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			print("Photo index \(indexPath.row)")
			viewController.selectedImage = pictures[indexPath.row]
			viewController.imageIndex = indexPath.row + 1
			viewController.imageViews = pictures.[indexPath.row].views
			navigationController?.pushViewController(viewController, animated: true)
		}
	}
}
