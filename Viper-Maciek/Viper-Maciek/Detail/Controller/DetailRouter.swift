//
//  DetailRouter.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 01/08/2024.
//

import Foundation
import UIKit

protocol DetailRouterInteractorProtocol {}

protocol DetailInteractorRouterProtocol {}

class DetailRouter {
	let presenter: DetailPresenter

	init(presenter: DetailPresenter) {
		self.presenter = presenter
	}
}
