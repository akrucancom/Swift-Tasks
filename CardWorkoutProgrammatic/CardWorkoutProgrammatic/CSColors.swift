//
//  Colors.swift
//  CardWorkoutProgrammatic
//
//  Created by Comarch-Andrzej on 09/07/2024.
//

import UIKit

class CSColors {
	var background: UIColor
	
	init() {
		self.background = .systemBackground
	}
	
	func colorChange(color: UIColor) {
		self.background = color
	}
}
