//
//  Note.swift
//  HWS-72-Milestone
//
//  Created by Comarch-Andrzej on 25/07/2024.
//

import UIKit

class Note: NSObject, Codable {
	var name: String
	var content: String

	init(name: String, content: String) {
		self.name = name
		self.content = content
	}
}
