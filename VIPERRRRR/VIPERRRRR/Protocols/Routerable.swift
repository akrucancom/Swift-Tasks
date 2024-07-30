//
//  Routerable.swift
//  VIPERRRRR
//
//  Created by Comarch-Andrzej on 30/07/2024.
//

import Foundation
import UIKit

protocol Routerable {
	var view: Viewable! { get }
	
	func dismiss(animated: Bool)
	func dismiss(animated: Bool, completion: @escaping (() -> Void))
	func pop(animated: Bool)
}

extension Routerable {
	func dismiss(animated: Bool) {
		view.dismiss(animated: animated)
	}
	
	func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
		view.dismiss(animated: animated, _completion: completion)
	}
	
	func pop(animated: Bool) {
		view.pop(animated: animated)
	}
}
