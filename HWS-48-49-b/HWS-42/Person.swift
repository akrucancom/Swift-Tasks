//
//  Person.swift
//  HWS-42
//
//  Created by Comarch-Andrzej on 19/07/2024.
//

import UIKit

class Person: NSObject, Codable {
	var name: String
	var image: String
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}
