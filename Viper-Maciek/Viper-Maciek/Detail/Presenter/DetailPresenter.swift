//
//  DetailPresenter.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 01/08/2024.
//

import Foundation
import UIKit

protocol DetailViewControllerPresenterProtocol {}

protocol DetailInteractorPresenterProtocol {}

class DetailPresenter {
	let viewController: DetailViewController
	lazy var interactor: DetailInteractor = .init(presenter: self)
	lazy var router: DetailRouter = .init(presenter: self)

	init(viewController: DetailViewController) {
		self.viewController = viewController
	}
}
