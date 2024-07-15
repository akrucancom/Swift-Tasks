//
//  String+Ext.swift
//  HWS-23-Challenge-4
//
//  Created by Comarch-Andrzej on 15/07/2024.
//

import UIKit

extension String {
	func capitalizingFirstLetter() -> String {
	  return prefix(1).uppercased() + self.lowercased().dropFirst()
	}

	mutating func capitalizeFirstLetter() {
	  self = self.capitalizingFirstLetter()
	}
}
