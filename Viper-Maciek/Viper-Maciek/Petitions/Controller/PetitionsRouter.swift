//
//  PetitionsRouter.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 31/07/2024.
//

import Foundation
import UIKit

protocol RouterProtocol {
	func present(parentViewController: UIViewController, params: Petition)
}

class MyRouter: RouterProtocol {
	func present(parentViewController: UIViewController, params: Petition) {
		let newViewController = DetailViewController()
		newViewController.detailItem = params
		print(3)
		parentViewController.navigationController?.pushViewController(newViewController, animated: true)
	}
}
