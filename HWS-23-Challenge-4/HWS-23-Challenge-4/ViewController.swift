//
//  ViewController.swift
//  HWS-23-Challenge-4
//
//  Created by Comarch-Andrzej on 15/07/2024.
//

import UIKit

class ViewController: UITableViewController {
	
	var countries = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Flag showcase"
		
		let fileManager = FileManager.default
		guard let path = Bundle.main.resourcePath else {
			print("Cant find path")
			return
		}
		let items = try! fileManager.contentsOfDirectory(atPath: path)
		
		var itemRegexed: String
		let regex = try! NSRegularExpression(pattern: "\\@.*$")
		for item in items {
			if item.hasSuffix("png") {
				let range = NSRange(location: 0, length: item.utf16.count)
				itemRegexed = regex.stringByReplacingMatches(in: item, range: range, withTemplate: "")
				itemRegexed.capitalizeFirstLetter()
				if !countries.contains(itemRegexed){
					countries.append(itemRegexed)
				}
			}
		}
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CountryName", for: indexPath)
		cell.textLabel?.text = countries[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
			viewController.selectedImage = countries[indexPath.row]
			navigationController?.pushViewController(viewController, animated: true)
		}
	}


}

