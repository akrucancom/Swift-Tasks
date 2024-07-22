//
//  Person.swift
//  HWS-42
//
//  Created by Comarch-Andrzej on 19/07/2024.
//

import UIKit

class Person: NSObject, NSCoding {
	var name: String
	var image: String
	static var supportsSecureCoding = true
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
	
	required init?(coder aDecoder: NSCoder) {
		name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
		image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: "name")
		aCoder.encode(image, forKey: "image")
	}
}
