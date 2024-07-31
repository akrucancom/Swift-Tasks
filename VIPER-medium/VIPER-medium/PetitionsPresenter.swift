//
//  PetitionsPresenter.swift
//  VIPER-medium
//
//  Created by Comarch-Andrzej on 30/07/2024.
//

import Foundation

final class PetitionsPresenterImplementation: PetitionsPresenter {
	private weak var view: PetitionsView?
	private var router: PetitionsRouter
	private var interactor: PetitionsInteractor

	init(view: PetitionsView? = nil, router: PetitionsRouter, interactor: PetitionsInteractor) {
		self.view = view
		self.router = router
		self.interactor = interactor
	}

	func viewDidLoad(view: PetitionsView) {
		self.view = view
		interactor.fetchPetitions()
	}
}

extension PetitionsPresenterImplementation: PetitionsInteractorOutput {
	func fetchPetitionsSuccess(petitions: [Petition]) {
		view?.show(petitions: petitions)
	}

	func fetchPettionsFailure(error: (any Error)?) {
//		Utilities.showAlert(title: "Loading failed", message: "Couldn't fetch petitions")
		fatalError("Yikes.")
	}
}
