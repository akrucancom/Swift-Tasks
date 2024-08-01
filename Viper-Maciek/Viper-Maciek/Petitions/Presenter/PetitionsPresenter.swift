//
//  PetitionsPresenter.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 31/07/2024.
//

import Foundation
import UIKit

protocol ViewControllerPresenterProtocol {
	func getData(with filter: Filter) -> [Petition]?
	func openDetails(controller: UIViewController, data: Petition)
	func fetchData(string: String)
}

protocol InteractorPresenterProtocol {
	func setData(data: [Petition])
}

class MyPresenter {
	var controller: ViewControllerProtocol?
	var interactor: InteractorProtocol?
	var router: RouterProtocol?
	private var petitions: [Petition] = []

	init(view: ViewControllerProtocol) {
		self.interactor = MyInteractor(presenter: self)
		self.controller = view
		self.router = MyRouter()
	}
}

extension MyPresenter: ViewControllerPresenterProtocol {
	func fetchData(string: String) {
		self.interactor?.fetchData(string: string)
	}
	
	func getData(with filter: Filter) -> [Petition]? {
		return self.interactor?.filterData(with: filter)
	}

	func openDetails(controller: UIViewController, data: Petition) {
		self.router?.present(parentViewController: controller, params: data)
	}
}

extension MyPresenter: InteractorPresenterProtocol {
	func setData(data: [Petition]) {
		print(data[2].title)
		self.controller?.setData(data: data)
	}
}
