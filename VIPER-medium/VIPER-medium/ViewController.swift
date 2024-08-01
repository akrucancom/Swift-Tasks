//
//  ViewController.swift
//  VIPER-medium
//
//  Created by Comarch-Andrzej on 30/07/2024.
//

import UIKit

class PetitionsViewController: UITableViewController, PetitionsView {
	private var builder = PetitionsBuilder()
	func show(petitions: [Petition]) {
		print("lol")
	}
	
	private let presenter: PetitionsPresenter
	
	init(presenter: PetitionsPresenter) {
		self.presenter = presenter
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		builder.build()
		
		presenter.viewDidLoad(view: self)
	}
	
//	func show(petitions: [Petition]) {
//		searchButton()
//		creditsButton()
//		
//		switch navigationController?.tabBarItem.tag {
//		case 0:
//			performSelector(inBackground: #selector(downloadData), with: urlString1)
//			return
//		case 1:
//			performSelector(inBackground: #selector(downloadData), with: urlString2)
//			return
//		default:
//			performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
//		}
//	}
//	
//	@objc func creditsButtonTapped() {
//		let creditsAlertController = UIAlertController(title: "Credits", message: "Data comes from the \"We the people\" API of The White House", preferredStyle: .alert)
//		let closeAlertAction = UIAlertAction(title: "Close", style: .default)
//		creditsAlertController.addAction(closeAlertAction)
//		present(creditsAlertController, animated: true)
//	}
//	
//	func creditsButton() {
//		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(creditsButtonTapped))
//	}
//	
//	func searchButton() {
//		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(presenter.searchButtonTapped))
//	}
//	
//	func returnButton() {
//		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left.fill"), style: .plain, target: self, action: #selector(restoreData))
//	}
}

final class PetitionsBuilder {

	func build() -> UIViewController {
		let router = PetitionsRouterImplementation()
		let repo = PetitionsRepoImplementation()
		let interactor = PetitionsInteractor(repo: repo)
		let presenter = PetitionsPresenterImplementation(router: router, interactor: interactor)
		let view = PetitionsViewController(presenter: presenter)

		router.viewController = view
		interactor.output = presenter
		return view
	}
}

