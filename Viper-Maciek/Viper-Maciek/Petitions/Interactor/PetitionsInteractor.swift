//
//  PetitionsInteractor.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 31/07/2024.
//

import Foundation
import UIKit

protocol InteractorProtocol {
	func fetchData(string: String)
	func filterData(with filter: Filter) -> [Petition]
	func parse(json: Data) -> [Petition]?
}

class MyInteractor {
	var presenter: InteractorPresenterProtocol?
	var petitions = [Petition]()
	var petitionUrls = PetitionUrl()

	init(presenter: InteractorPresenterProtocol?) {
		self.presenter = presenter
		fetchData(string: petitionUrls.lateset)
	}

	func parse(json: Data) -> [Petition]? {
		let decoder = JSONDecoder()

		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			return jsonPetitions.results
		} else {
			return []
		}
	}
}

extension MyInteractor: InteractorProtocol {
	func fetchData(string: String) {
		DispatchQueue.global(qos: .userInitiated).async {
			if let url = URL(string: string) {
				if let data = try? Data(contentsOf: url) {
					guard let dataParsed = self.parse(json: data) else {
						return
					}
					print(dataParsed[0].title)
					self.petitions = dataParsed
					self.presenter?.setData(data: self.petitions)
				}
			}
		}
	}

	func filterData(with filter: Filter) -> [Petition] {
		let data = petitions.filter { $0.title.contains(filter.value) || $0.body.contains(filter.value) }
		// fetch filtered data
		return data
	}
}
