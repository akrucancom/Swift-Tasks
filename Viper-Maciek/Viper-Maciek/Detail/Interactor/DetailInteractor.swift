//
//  DetailInteractor.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 01/08/2024.
//

import Foundation

protocol DetailInteractorPresenter {
	
}

protocol DetailPresenterInteractor {
	
}

class DetailInteractor {
	var presenter: DetailPresenter
	
	init(presenter: DetailPresenter) {
		self.presenter = presenter
	}
}
