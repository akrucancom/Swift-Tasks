//
//  Script.swift
//  Extenstion
//
//  Created by Comarch-Andrzej on 24/07/2024.
//

import UIKit

class Script: NSObject, Codable {
	var name: String
	var content: String
	var site: String
	
	init(name: String, content: String, site: String) {
		self.name = name
		self.content = content
		self.site = site
	}
}
