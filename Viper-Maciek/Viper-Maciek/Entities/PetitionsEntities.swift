//
//  PetitionsEntities.swift
//  Viper-Maciek
//
//  Created by Comarch-Andrzej on 31/07/2024.
//

import Foundation
import UIKit

struct Petition: Codable {
	var title: String
	var body: String
	var signatureCount: Int
}

struct Petitions: Codable {
	var results: [Petition]
}

class PetitionUrl {
	let lateset: String
	let topRated: String
	
	init() {
		self.lateset = "https://www.hackingwithswift.com/samples/petitions-1.json"
		self.topRated = "https://www.hackingwithswift.com/samples/petitions-2.json"
	}
}

struct Filter {
	var value: String
}
