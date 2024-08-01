//
//  ViewController.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 31/07/2024.
//

import UIKit

protocol ViewControllerProtocol {
	func openDetails(data: Petition)
	func setData(data: [Petition])
	func showError(title: String, message: String)
}

class MyViewController: UITableViewController {
	var presenter: ViewControllerPresenterProtocol?
	var petitions = [Petition]()
	var petitionsBackup = [Petition]()
	var petitionUrls = PetitionUrl()
	var navigation = UINavigationController()

	override func viewDidLoad() {
		super.viewDidLoad()
		presenter = MyPresenter(view: self)
		setupUI()
		switch navigationController?.tabBarItem.tag {
		case 0:
			performSelector(inBackground: #selector(fetchData), with: petitionUrls.lateset)
			return
		case 1:
			performSelector(inBackground: #selector(fetchData), with: petitionUrls.topRated)
			return
		default:
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
		cellPressed(data: petitions[indexPath.row])
	}
	
	@objc func filterDataPressed(_ sender: UIButton) {
		let filterAlertController = UIAlertController(title: "Insert seeked phrase:", message: nil, preferredStyle: .alert)
		filterAlertController.addTextField()
		
		let submitAlertController = UIAlertAction(title: "Submit", style: .default) { [unowned filterAlertController, weak self] _ in
			let input = filterAlertController.textFields! [0]
			let answer = input.text
			if answer == "" {
				return
			}
			let filter = Filter(value: answer ?? "")
			self?.filterDataHandler(filter: filter)
		}
		filterAlertController.addAction(submitAlertController)
		present(filterAlertController, animated: true)
		// ustawiamy w filtrze dane na podstawie np. jakichś wypełnionych pól
		// w tym miejscu trzeba by było się upewnić, że dane są pobrane przed odświeżeniem listy
		tableView.reloadData()
	}
		
	func filterDataHandler(filter: Filter) {
		petitionsBackup = petitions
		petitions = presenter?.getData(with: filter) ?? petitions
		petitions = petitions.filter { $0.title.contains(filter.value) || $0.body.contains(filter.value) }
		DispatchQueue.main.async {
			self.tableView.reloadData()
			self.returnButton()
		}
	}
	
	@objc func refreshPetitions() {
		print(petitions)
		tableView.reloadData()
	}
	
	@objc func fetchData(string: String) {
		presenter?.fetchData(string: string)
	}
	
	func setupUI() {
		title = "Petition Viewer"
		searchButton()
		creditsButton()
	}
	
	func returnButton() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left.fill"), style: .plain, target: self, action: #selector(restoreData))
	}
	
	func creditsButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(creditsButtonTapped))
	}
	
	func searchButton() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(filterDataPressed))
	}
	
	@objc func restoreData() {
		petitions = petitionsBackup
		tableView.reloadData()
		searchButton()
	}
	
	@objc func creditsButtonTapped() {
		let creditsAlertController = UIAlertController(title: "Credits", message: "Data comes from the \"We the people\" API of The White House", preferredStyle: .alert)
		let closeAlertAction = UIAlertAction(title: "Close", style: .default)
		creditsAlertController.addAction(closeAlertAction)
		present(creditsAlertController, animated: true)
	}
	
	// Metoda wywołana po kliknięciu w komórkę
	func cellPressed(data: Petition) {
		presenter?.openDetails(controller: self, data: data)
	}
}

extension MyViewController: ViewControllerProtocol {
	func openDetails(data: Petition) {
		presenter?.openDetails(controller: self, data: data)
	}

	func setData(data: [Petition]) {
		petitions = data
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	@objc func showError(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
}
