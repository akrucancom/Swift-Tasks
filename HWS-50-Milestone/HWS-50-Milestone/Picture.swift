//
//  Picture.swift
//  HWS-50-Milestone
//
//  Created by Comarch-Andrzej on 23/07/2024.
//

import UIKit

class Picture: NSObject, Codable {
	var name: String
	var caption: String

	init(name: String, caption: String) {
		self.name = name
		self.caption = caption
	}
}
