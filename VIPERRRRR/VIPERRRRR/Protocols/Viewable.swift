//
//  Viewable.swift
//  HWS-33-35
//
//  Created by Comarch-Andrzej on 29/07/2024.
//

import Foundation
import UIKit

protocol Viewable: AnyObject {
	func push(_ vc: UIViewController, animated: Bool)
	func present(_ vc: UIViewController, animated: Bool)
	func pop(animated: Bool)
	func dismiss(animated: Bool)
	func dismiss(animated: Bool, _completion: @escaping (() -> Void))
}

extension Viewable where Self: UIViewController {
	func push(_ vc: UIViewController, animated: Bool) {
		self.navigationController?.pushViewController(vc, animated: animated)
	}
	
	func present(_ vc: UIViewController, animated: Bool) {
		self.present(vc, animated: animated, completion: nil)
	}
	
	func pop(animated:Bool) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func dismiss(animated: Bool) {
		self.dismiss(animated: animated, completion: nil)
	}
	
	func dismiss(animated: Bool, _completion: @escaping (() -> Void)) {
		self.dismiss(animated: animated, completion: _completion)
	}
	
	var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	
	var preferredInterfaceOrientationPresentation: UIInterfaceOrientation {
		return .portrait
	}
}
