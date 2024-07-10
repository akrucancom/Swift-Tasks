//
//  ColorsDetailVC.swift
//  RandomColorsFixed
//
//  Created by Comarch-Andrzej on 05/07/2024.
//

import UIKit

class ColorsDetailVC: UIViewController {
	var colorString = "System Blue"

	var color: UIColor?
	


    override func viewDidLoad() {
		colorString = hexStringFromColor(color: color ?? .blue)
		
		let actionSheetController = UIAlertController(title: "Color", message: colorString, preferredStyle: .alert)

		let action1 = UIAlertAction(title: "Return", style: .default) { _ in
			self.navigationController!.popToRootViewController(animated: true)
		}

		let action2 = UIAlertAction(title: "Close", style: .destructive) { _ in
			// Handle Action 2
		}
		
		actionSheetController.addAction(action1)
		actionSheetController.addAction(action2)

		present(actionSheetController, animated: true, completion: nil)
        super.viewDidLoad()
		
		view.backgroundColor = color ?? .blue
    }

}

func hexStringFromColor(color: UIColor) -> String {
	let components = color.cgColor.components
	let r: CGFloat = components?[0] ?? 0.0
	let g: CGFloat = components?[1] ?? 0.0
	let b: CGFloat = components?[2] ?? 0.0

	let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
	print(hexString)
	return hexString
 }
