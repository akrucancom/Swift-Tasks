//
//  ViewController.swift
//  HWS-Project1
//
//  Created by Comarch-Andrzej on 11/07/2024.
//

import UIKit

class ViewController: UITableViewController {
	var pictures = [ImageData]()
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPictures))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removePictures))
		let defaults = UserDefaults.standard
		
		if let savedPictures = defaults.object(forKey: "pictures") as? Data {
			let jsonDecoder = JSONDecoder()
			
			do {
				pictures = try jsonDecoder.decode([ImageData].self, from: savedPictures)
			} catch {
				print("Failed to load people")
			}
		}
		print(pictures)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = pictures[indexPath.row].name
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			print("Photo index \(indexPath.row)")
			pictures[indexPath.row].views += 1
			save()
			viewController.selectedImage = pictures[indexPath.row].name
			viewController.imageIndex = indexPath.row + 1
			viewController.imageViews = pictures[indexPath.row].views
			navigationController?.pushViewController(viewController, animated: true)
		}
	}
		
	func save() {
		let jsonEncoder = JSONEncoder()
		
		if let savedData = try? jsonEncoder.encode(pictures) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: "pictures")
		} else {
			print("Failed to save pictures.")
		}
	}

	@objc func refreshPictures() {
		let fileManager = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fileManager.contentsOfDirectory(atPath: path)
		var names = [String]()
		
		if pictures.count == 0 {
			for item in items {
				if item.hasPrefix("nssl") {
					let picture = ImageData(name: item, views: 0)
					pictures.append(picture)
					save()
				}
			}
		}
		
		else {
			for counter in 0 ..< pictures.count {
				names.append(pictures[counter].name)
			}
			for item in items {
				if item.hasPrefix("nssl") {
					if !names.contains(item) {
						let picture = ImageData(name: item, views: 0)
						pictures.append(picture)
						save()
					}
				}
			}
		}
		tableView.reloadData()
	}
	
	@objc func removePictures() {
		pictures = []
		save()
	}
}
