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

		searchButton()
		creditsButton()
		
		switch navigationController?.tabBarItem.tag {
		case 0:
			performSelector(inBackground: #selector(downloadData), with: urlString1)
			return
		case 1:
			performSelector(inBackground: #selector(downloadData), with: urlString2)
			return
		default:
			performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
		}
	}
	
	@objc func creditsButtonTapped() {
		let creditsAlertController = UIAlertController(title: "Credits", message: "Data comes from the \"We the people\" API of The White House", preferredStyle: .alert)
		let closeAlertAction = UIAlertAction(title: "Close", style: .default)
		creditsAlertController.addAction(closeAlertAction)
		present(creditsAlertController, animated: true)
	}
	
	@objc func searchButtonTapped() {
		let searchAlertController = UIAlertController(title: "Search for petition", message: "Input text:", preferredStyle: .alert)
		searchAlertController.addTextField()
		
		let submitAlertController = UIAlertAction(title: "Submit", style: .default) { [unowned searchAlertController] _ in
			let input = searchAlertController.textFields! [0]
			let answer = input.text
			if answer == "" {
				return
			}
			self.petitionsBackup = self.petitions
			self.petitions = self.petitions.filter { $0.title.contains(answer ?? " ") || $0.body.contains(answer ?? " ") }
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
			self.returnButton()
		}
		
		searchAlertController.addAction(submitAlertController)
		present(searchAlertController, animated: true)
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
	
	@objc func downloadData(urlString: String) {
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parse(json: data)
				return
			}
		}
	}
	
	@objc func showError() {
		DispatchQueue.main.async { [weak self] in
			let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, check your connection and try again", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			self?.present(ac, animated: true)
		}
	}
	
	func parse(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			petitions = jsonPetitions.results
			DispatchQueue.main.async { [weak self] in
				self?.tableView.reloadData()
			}
		} else {
			performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
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
