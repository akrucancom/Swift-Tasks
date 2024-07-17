//
//  ViewController.swift
//  HWS-33-35
//
//  Created by Comarch-Andrzej on 17/07/2024.
//

import UIKit

class ViewController: UITableViewController {
	var petitions = [Petition]()
	var petitionsBackup = [Petition]()
	var urlString1: String = "https://www.hackingwithswift.com/samples/petitions-1.json"
	var urlString2: String = "https://www.hackingwithswift.com/samples/petitions-2.json"
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let urlString: String
		
		searchButton()
		creditsButton()
		
		switch navigationController?.tabBarItem.tag {
		case 0:
			downloadData(urlString: urlString1)
			return
		case 1:
			downloadData(urlString: urlString2)
			return
		default:
			showError()
		}
	}
	
	@objc func creditsButtonTapped() {
		let creditsAC = UIAlertController(title: "Credits", message: "Data comes from the \"We the people\" API of The White House", preferredStyle: .alert)
		let closeAA = UIAlertAction(title: "Close", style: .default)
		creditsAC.addAction(closeAA)
		present(creditsAC, animated: true)
	}
	
	@objc func searchButtonTapped() {
		let searchAC = UIAlertController(title: "Search for petition", message: "Input text:", preferredStyle: .alert)
		searchAC.addTextField()
		
		let submitAC = UIAlertAction(title: "Submit", style: .default) { [unowned searchAC] _ in
			let answer = searchAC.textFields! [0]
			if answer.text == "" {
				return
			}
			self.petitionsBackup = self.petitions
			self.petitions = self.petitions.filter { $0.title.contains(answer.text ?? " ") || $0.body.contains(answer.text ?? " ") }
			self.tableView.reloadData()
			self.returnButton()
		}
		
		searchAC.addAction(submitAC)
		present(searchAC, animated: true)
	}
	
	@objc func restoreData() {
		petitions = petitionsBackup
		tableView.reloadData()
		searchButton()
	}
	
	func creditsButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(creditsButtonTapped))
	}
	
	func searchButton() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
	}
	
	func returnButton() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left.fill"), style: .plain, target: self, action: #selector(restoreData))
	}
	
	func downloadData(urlString: String) {
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parse(json: data)
				return
			}
		}
	}
	
	func showError() {
		let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, check your connection and try again", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	func parse(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			petitions = jsonPetitions.results
			tableView.reloadData()
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return petitions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let petition = petitions[indexPath.row]
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailVC = DetailViewController()
		detailVC.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(detailVC, animated: true)
	}
}
