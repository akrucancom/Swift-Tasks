//
//  ImageData.swift
//  HWS-Project1
//
//  Created by Comarch-Andrzej on 19/07/2024.
//

import UIKit

class ImageData: NSObject, Codable {
	var name: String
	var views: Int
	
	init(name:String, views: Int) {
		self.name = name
		self.views = views
	}
}
