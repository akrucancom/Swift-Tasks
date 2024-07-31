//
//  PetitionsInteractor.swift
//  VIPER-medium
//
//  Created by Comarch-Andrzej on 30/07/2024.
//

import Foundation
import UIKit

final class PetitionsInteractor: PetitionsInteractorInput {
	
	weak var output: PetitionsInteractorOutput?
	
	private let repo: PetitionsRepo
	
	init(repo: PetitionsRepo) {
		self.repo = repo
	}
	
	func fetchPetitions() {
		repo.fetchPetitions { petitions, error in
			if let petitions = petitions {
				self.output?.fetchPetitionsSuccess(petitions: petitions)
			} else {
				self.output?.fetchPettionsFailure(error: error)
			}}
	}
	
}
