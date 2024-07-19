//
//  ViewController.swift
//  HWS-42-tests
//
//  Created by Comarch-Andrzej on 19/07/2024.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let defaults = UserDefaults.standard
		
		defaults.set(25, forKey: "Age")
		defaults.set(true, forKey: "UseFaceID")
		
		let savedIntegers = defaults.integer(forKey: "Age")
		
		let array = ["Hello", "World"]
		defaults.set(array, forKey: "Savedarray")
	}


}

