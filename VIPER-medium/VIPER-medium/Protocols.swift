//
//  Protocols.swift
//  VIPER-medium
//
//  Created by Comarch-Andrzej on 30/07/2024.
//

import Foundation

protocol PetitionsView: AnyObject {
	func show(petitions: [Petition])
}

protocol PetitionsPresenter: AnyObject {
	func viewDidLoad(view: PetitionsView)
}

protocol PetitionsInteractorInput: AnyObject {
	func fetchPetitions()
}

protocol PetitionsInteractorOutput: AnyObject {
	func fetchPetitionsSuccess(petitions: [Petition])
	func fetchPettionsFailure(error: Error?)
}

protocol PetitionsRouter: AnyObject {
}

protocol PetitionsRepo: AnyObject {
	func fetchPetitions(completion: @escaping ([Petition]?, Error?) -> Void)
}
